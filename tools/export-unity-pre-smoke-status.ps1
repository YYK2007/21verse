param(
    [string] $ProjectPath = (Join-Path $PSScriptRoot "..\unity\21verse-vr-game-hub"),
    [string] $OutputPath = (Join-Path $PSScriptRoot "..\docs\inventory\unity-pre-smoke-status.csv")
)

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
$resolvedProject = (Resolve-Path -LiteralPath $ProjectPath).Path
$resolvedOutput = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputPath)

$scenePaths = @(
    "Assets/Scenes/MainMenu.unity",
    "Assets/Scenes/WordLevel01.unity",
    "Assets/Scenes/AdjectiveLevel01.unity",
    "Assets/Scenes/IdentifyingColors.unity",
    "Assets/Scenes/NumberLevelUI01.unity",
    "Assets/Scenes/NumberInequalitiesLevel.unity",
    "Assets/Scenes/Cashier.unity"
)

function Get-EnabledBuildScenes {
    param([string] $BuildSettingsPath)

    $enabledScenes = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $currentPath = $null
    $currentEnabled = $null

    foreach ($line in Get-Content -LiteralPath $BuildSettingsPath) {
        if ($line -match '^\s*-\s+enabled:\s+(\d+)') {
            $currentEnabled = $matches[1]
            $currentPath = $null
            continue
        }

        if ($line -match '^\s*path:\s+(.+)$') {
            $currentPath = $matches[1].Trim()
            if ($currentEnabled -eq "1" -and -not [string]::IsNullOrWhiteSpace($currentPath)) {
                $enabledScenes.Add($currentPath) | Out-Null
            }
        }
    }

    return $enabledScenes
}

Push-Location $repoRoot
try {
    $buildSettingsPath = Join-Path $resolvedProject "ProjectSettings\EditorBuildSettings.asset"
    $enabledBuildScenes = Get-EnabledBuildScenes -BuildSettingsPath $buildSettingsPath
    $rows = [System.Collections.Generic.List[object]]::new()

    foreach ($scenePath in $scenePaths) {
        $filePath = Join-Path $resolvedProject $scenePath
        $exists = Test-Path -LiteralPath $filePath
        $content = if ($exists) { Get-Content -LiteralPath $filePath -Raw } else { "" }
        $hasXrOrigin = $content -match 'XR Origin \(XR Rig\)'
        $hasInteractionManager = $content -match 'm_Name:\s+XR Interaction Manager'
        $hasEventSystem = $content -match 'm_Name:\s+EventSystem'
        $hasXrUiInput = $content -match 'm_EnableXRInput:\s+1'
        $inBuildSettings = $enabledBuildScenes.Contains($scenePath)

        $status = if ($exists -and $inBuildSettings -and $hasXrOrigin -and $hasInteractionManager -and $hasEventSystem -and $hasXrUiInput) {
            "ready_for_interactive_smoke"
        }
        else {
            "needs_attention_before_interactive_smoke"
        }

        $notes = [System.Collections.Generic.List[string]]::new()
        if (-not $exists) { $notes.Add("scene file missing") | Out-Null }
        if (-not $inBuildSettings) { $notes.Add("not enabled in EditorBuildSettings") | Out-Null }
        if (-not $hasXrOrigin) { $notes.Add("XR Origin marker missing") | Out-Null }
        if (-not $hasInteractionManager) { $notes.Add("XR Interaction Manager marker missing") | Out-Null }
        if (-not $hasEventSystem) { $notes.Add("EventSystem marker missing") | Out-Null }
        if (-not $hasXrUiInput) { $notes.Add("XR UI input marker missing") | Out-Null }
        if ($notes.Count -eq 0) { $notes.Add("pre-smoke structural checks passed") | Out-Null }

        $rows.Add([PSCustomObject]@{
            scene = $scenePath
            exists = $exists
            enabled_in_build_settings = $inBuildSettings
            has_xr_origin = $hasXrOrigin
            has_xr_interaction_manager = $hasInteractionManager
            has_event_system = $hasEventSystem
            has_xr_ui_input = $hasXrUiInput
            status = $status
            notes = $notes -join "; "
        }) | Out-Null
    }

    $outputDir = Split-Path -Parent $resolvedOutput
    New-Item -ItemType Directory -Force -Path $outputDir | Out-Null
    $rows | Export-Csv -LiteralPath $resolvedOutput -NoTypeInformation
    Write-Output $resolvedOutput
}
finally {
    Pop-Location
}
