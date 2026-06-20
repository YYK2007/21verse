param(
    [string] $PublicAssetManifestPath = (Join-Path $PSScriptRoot "..\docs\inventory\unity-public-asset-manifest.csv"),
    [string] $RiskyReferencesPath = (Join-Path $PSScriptRoot "..\docs\inventory\unity-risky-asset-references.csv"),
    [string] $ProjectPath = (Join-Path $PSScriptRoot "..\unity\21verse-vr-game-hub"),
    [string] $OutputPath = (Join-Path $PSScriptRoot "..\docs\inventory\unity-third-party-removal-status.csv")
)

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
$resolvedOutput = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputPath)

function Get-ByFolder {
    param(
        [object[]] $Rows,
        [string] $Folder
    )

    return @($Rows | Where-Object { $_.folder -eq $Folder } | Select-Object -First 1)
}

Push-Location $repoRoot
try {
    $manifestRows = if (Test-Path -LiteralPath $PublicAssetManifestPath) { @(Import-Csv -LiteralPath $PublicAssetManifestPath) } else { @() }
    $referenceRows = @(Import-Csv -LiteralPath $RiskyReferencesPath)

    $rows = [System.Collections.Generic.List[object]]::new()
    foreach ($reference in $referenceRows | Sort-Object folder) {
        $row = Get-ByFolder -Rows $manifestRows -Folder $reference.folder
        $referenceCount = if ($reference) { [int] $reference.external_reference_count } else { 0 }
        $folderRelativePath = $reference.folder -replace '^Assets/', ''
        $folderPath = Join-Path (Join-Path $ProjectPath "Assets") $folderRelativePath
        $folderPresent = Test-Path -LiteralPath $folderPath
        $safeToDelete = $referenceCount -eq 0
        $removalStatus = if (-not $folderPresent) {
            "removed_from_repo"
        }
        elseif ($safeToDelete) {
            "safe_to_remove_now"
        }
        else {
            "referenced_replace_before_removal"
        }

        $nextAction = if (-not $folderPresent) {
            "No bundled repo action remains; keep package/import notes only if a private user wants to reconstruct the old scene visuals."
        }
        elseif ($safeToDelete) {
            "Remove the folder and regenerate Unity asset inventories."
        }
        else {
            "Do not delete directly; first replace or remove serialized references listed in the replacement worklist, then delete the folder."
        }

        $rows.Add([PSCustomObject]@{
            folder = $reference.folder
            public_repo_treatment = if ($row) { $row.public_repo_treatment } else { "removed_from_repo" }
            tracked_file_count = if ($row) { $row.tracked_file_count } else { 0 }
            serialized_reference_count = $referenceCount
            safe_to_delete_now = ($(if ($safeToDelete) { "yes" } else { "no" }))
            removal_status = $removalStatus
            referenced_by = if ($reference) { $reference.referenced_by } else { "" }
            next_action = $nextAction
            issue = "#2"
        }) | Out-Null
    }

    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $resolvedOutput) | Out-Null
    if (Test-Path -LiteralPath $resolvedOutput) {
        $existing = (Resolve-Path -LiteralPath $resolvedOutput).Path
        if (-not $existing.StartsWith($repoRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
            throw "Refusing to replace output outside repository: $existing"
        }
        Remove-Item -LiteralPath $existing -Force
    }

    $rows | Export-Csv -LiteralPath $resolvedOutput -NoTypeInformation
    Write-Output $resolvedOutput
}
finally {
    Pop-Location
}
