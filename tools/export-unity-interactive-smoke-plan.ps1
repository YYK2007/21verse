param(
    [string] $PreSmokePath = (Join-Path $PSScriptRoot "..\docs\inventory\unity-pre-smoke-status.csv"),
    [string] $ReplacementWorklistPath = (Join-Path $PSScriptRoot "..\docs\inventory\unity-asset-replacement-worklist.csv"),
    [string] $OutputPath = (Join-Path $PSScriptRoot "..\docs\inventory\unity-interactive-smoke-plan.csv")
)

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
$resolvedOutput = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputPath)

function Get-SceneName {
    param([string] $ScenePath)

    return [System.IO.Path]::GetFileNameWithoutExtension($ScenePath)
}

Push-Location $repoRoot
try {
    $preSmokeRows = @(Import-Csv -LiteralPath $PreSmokePath)
    $worklistRows = @(Import-Csv -LiteralPath $ReplacementWorklistPath)
    $rows = [System.Collections.Generic.List[object]]::new()

    foreach ($scene in $preSmokeRows) {
        $sceneWork = @($worklistRows | Where-Object { $_.referenced_file -eq $scene.scene })
        $riskFolders = @($sceneWork | ForEach-Object { $_.folder } | Sort-Object -Unique)
        $manualChecks = @(
            "open scene interactively",
            "confirm XR Origin/controllers and EventSystem are present",
            "exercise primary scene navigation and learning interaction",
            "inspect text readability and UI input",
            "inspect skybox/material/rendering warnings after asset decisions"
        )

        $rows.Add([PSCustomObject]@{
            scene = $scene.scene
            scene_name = Get-SceneName -ScenePath $scene.scene
            pre_smoke_status = $scene.status
            structural_evidence = $scene.notes
            risky_asset_reference_count = $sceneWork.Count
            risky_asset_folders = if ($riskFolders.Count -gt 0) { $riskFolders -join "; " } else { "none" }
            required_manual_checks = $manualChecks -join "; "
            pass_condition = "Scene opens interactively, XR setup/input are usable, primary interaction works, and rendering/text issues are either acceptable or documented."
            status = "pending_interactive_smoke"
            issue = "#3"
        }) | Out-Null
    }

    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $resolvedOutput) | Out-Null
    $rows | Export-Csv -LiteralPath $resolvedOutput -NoTypeInformation
    Write-Output $resolvedOutput
}
finally {
    Pop-Location
}
