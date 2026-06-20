param(
    [string] $AuditPath = (Join-Path $PSScriptRoot "..\docs\inventory\unity-asset-audit.csv"),
    [string] $DispositionPath = (Join-Path $PSScriptRoot "..\docs\inventory\unity-asset-disposition.csv"),
    [string] $ExternalImportsPath = (Join-Path $PSScriptRoot "..\docs\inventory\unity-external-imports.csv"),
    [string] $ReplacementWorklistPath = (Join-Path $PSScriptRoot "..\docs\inventory\unity-asset-replacement-worklist.csv"),
    [string] $OutputPath = (Join-Path $PSScriptRoot "..\docs\inventory\unity-public-asset-manifest.csv")
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

function Get-PublicTreatment {
    param(
        [object] $Audit,
        [object] $Disposition,
        [object] $External
    )

    if ($Disposition -and $Disposition.release_decision -eq "pending") {
        if ($External -and $External.source_type -match "asset_store|unity_registry|unity_template") {
            return "exclude_until_import_or_rights_confirmed"
        }

        if ($External -and $External.source_type -match "replace") {
            return "replace_before_public_release"
        }

        return "exclude_until_rights_confirmed"
    }

    if ($Audit.public_release_action -match "Project validation utility|Likely project-specific|review ownership and keep|keep") {
        return "retain_candidate_reviewed"
    }

    return "needs_manual_review"
}

Push-Location $repoRoot
try {
    $auditRows = @(Import-Csv -LiteralPath $AuditPath)
    $dispositionRows = @(Import-Csv -LiteralPath $DispositionPath)
    $externalRows = @(Import-Csv -LiteralPath $ExternalImportsPath)
    $worklistRows = @(Import-Csv -LiteralPath $ReplacementWorklistPath)
    $trackedFiles = @(git ls-files "unity/21verse-vr-game-hub/Assets/*")

    $manifestRows = [System.Collections.Generic.List[object]]::new()
    foreach ($audit in $auditRows | Sort-Object folder) {
        $disposition = Get-ByFolder -Rows $dispositionRows -Folder $audit.folder
        $external = Get-ByFolder -Rows $externalRows -Folder $audit.folder
        $folderWorklistRows = @($worklistRows | Where-Object { $_.folder -eq $audit.folder })
        $trackedPrefix = "unity/21verse-vr-game-hub/$($audit.folder)/"
        $trackedCount = @($trackedFiles | Where-Object { $_.StartsWith($trackedPrefix) }).Count
        $treatment = Get-PublicTreatment -Audit $audit -Disposition $disposition -External $external
        $resolution = if ($disposition) {
            $disposition.replacement_or_import_path
        }
        elseif ($treatment -eq "retain_candidate_reviewed") {
            "Keep if ownership remains project-owned or redistributable during final manual review."
        }
        else {
            "Manual public-release review required."
        }

        $manifestRows.Add([PSCustomObject]@{
            folder = $audit.folder
            public_repo_treatment = $treatment
            tracked_file_count = $trackedCount
            audit_file_count = $audit.file_count
            size_mb = $audit.size_mb
            license_types = $audit.license_types
            evidence_files = $audit.evidence_files
            serialized_reference_rows = $folderWorklistRows.Count
            release_decision = if ($disposition) { $disposition.release_decision } else { "retain_candidate" }
            source_type = if ($external) { $external.source_type } else { "project_or_manual_review" }
            public_release_resolution = $resolution
            validation_required = if ($disposition) { $disposition.validation_required } else { "Run repository hygiene and Unity validation after final release selection." }
            issue = if ($disposition) { $disposition.issue } else { "" }
        }) | Out-Null
    }

    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $resolvedOutput) | Out-Null
    $manifestRows | Export-Csv -LiteralPath $resolvedOutput -NoTypeInformation
    Write-Output $resolvedOutput
}
finally {
    Pop-Location
}
