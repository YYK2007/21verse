param(
    [string] $PublicAssetManifestPath = (Join-Path $PSScriptRoot "..\docs\inventory\unity-public-asset-manifest.csv"),
    [string] $RiskyReferencesPath = (Join-Path $PSScriptRoot "..\docs\inventory\unity-risky-asset-references.csv"),
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
    $manifestRows = @(Import-Csv -LiteralPath $PublicAssetManifestPath)
    $referenceRows = @(Import-Csv -LiteralPath $RiskyReferencesPath)

    $rows = [System.Collections.Generic.List[object]]::new()
    foreach ($row in $manifestRows | Where-Object { $_.public_repo_treatment -match "exclude|replace" } | Sort-Object folder) {
        $reference = Get-ByFolder -Rows $referenceRows -Folder $row.folder
        $referenceCount = if ($reference) { [int] $reference.external_reference_count } else { 0 }
        $safeToDelete = $referenceCount -eq 0
        $removalStatus = if ($safeToDelete) {
            "safe_to_remove_now"
        }
        else {
            "referenced_replace_before_removal"
        }

        $nextAction = if ($safeToDelete) {
            "Remove the folder and regenerate Unity asset inventories."
        }
        else {
            "Do not delete directly; first replace or remove serialized references listed in the replacement worklist, then delete the folder."
        }

        $rows.Add([PSCustomObject]@{
            folder = $row.folder
            public_repo_treatment = $row.public_repo_treatment
            tracked_file_count = $row.tracked_file_count
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
