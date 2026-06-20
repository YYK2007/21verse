param(
    [string] $AssetManifestPath = (Join-Path $PSScriptRoot "..\docs\inventory\unity-public-asset-manifest.csv"),
    [string] $OutputPath = (Join-Path $PSScriptRoot "..\docs\inventory\public-release-file-plan.csv")
)

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
$resolvedOutput = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputPath)

function Get-PlanAction {
    param(
        [string] $Path,
        [hashtable] $AssetTreatments
    )

    if ($Path -match '^unity/21verse-vr-game-hub/Assets/([^/]+)(/|$)') {
        $folder = "Assets/$($Matches[1])"
        $treatment = $AssetTreatments[$folder]
        if ($treatment) {
            if ($treatment.public_repo_treatment -eq "retain_candidate_reviewed") {
                return [PSCustomObject]@{
                    Action = "include_pending_final_review"
                    Reason = "Unity asset folder is a retain candidate in docs/inventory/unity-public-asset-manifest.csv."
                    ManifestFolder = $folder
                    Issue = $treatment.issue
                }
            }

            return [PSCustomObject]@{
                Action = "exclude_until_resolved"
                Reason = "$($treatment.public_repo_treatment): $($treatment.public_release_resolution)"
                ManifestFolder = $folder
                Issue = $treatment.issue
            }
        }
    }

    if ($Path -match '^docs/inventory/generated/') {
        return [PSCustomObject]@{
            Action = "exclude_generated"
            Reason = "Generated local inventory output is not part of the public release source tree."
            ManifestFolder = ""
            Issue = ""
        }
    }

    if ($Path -match '(^|/)(Library|Temp|Logs|Obj|Build|Builds|UserSettings)(/|$)') {
        return [PSCustomObject]@{
            Action = "exclude_generated"
            Reason = "Unity generated folder."
            ManifestFolder = ""
            Issue = ""
        }
    }

    return [PSCustomObject]@{
        Action = "include"
        Reason = "Tracked source, documentation, configuration, or reviewed non-Unity-asset file."
        ManifestFolder = ""
        Issue = ""
    }
}

Push-Location $repoRoot
try {
    $assetManifestRows = @(Import-Csv -LiteralPath $AssetManifestPath)
    $assetTreatments = @{}
    foreach ($row in $assetManifestRows) {
        $assetTreatments[$row.folder] = $row
    }

    $trackedFiles = @(git ls-files | Sort-Object)
    $rows = [System.Collections.Generic.List[object]]::new()
    foreach ($path in $trackedFiles) {
        $plan = Get-PlanAction -Path $path -AssetTreatments $assetTreatments
        $rows.Add([PSCustomObject]@{
            path = $path
            action = $plan.Action
            reason = $plan.Reason
            asset_manifest_folder = $plan.ManifestFolder
            issue = $plan.Issue
        }) | Out-Null
    }

    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $resolvedOutput) | Out-Null
    $rows | Export-Csv -LiteralPath $resolvedOutput -NoTypeInformation
    Write-Output $resolvedOutput
}
finally {
    Pop-Location
}
