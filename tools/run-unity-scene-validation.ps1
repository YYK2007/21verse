param(
    [string] $UnityExe = "C:\Program Files\Unity\Hub\Editor\2022.3.25f1\Editor\Unity.exe",
    [string] $ProjectPath = (Join-Path $PSScriptRoot "..\unity\21verse-vr-game-hub"),
    [string] $ReportPath = (Join-Path $env:TEMP "21verse-unity-scene-validation.md")
)

$ErrorActionPreference = "Stop"

$resolvedProject = (Resolve-Path -LiteralPath $ProjectPath).Path
$resolvedReport = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ReportPath)
$logPath = Join-Path $env:TEMP "21verse-unity-scene-validation.log"

$reportDirectory = Split-Path -Parent $resolvedReport
if (-not (Test-Path -LiteralPath $reportDirectory)) {
    New-Item -ItemType Directory -Path $reportDirectory | Out-Null
}

$env:TWENTYONEVERSE_SCENE_VALIDATION_REPORT = $resolvedReport

try {
    $process = Start-Process -FilePath $UnityExe -ArgumentList @(
        "-batchmode",
        "-nographics",
        "-quit",
        "-projectPath", $resolvedProject,
        "-executeMethod", "SceneValidation.ValidateConfiguredScenes",
        "-logFile", $logPath
    ) -Wait -PassThru -WindowStyle Hidden
}
finally {
    Remove-Item Env:\TWENTYONEVERSE_SCENE_VALIDATION_REPORT -ErrorAction SilentlyContinue
}

if ($process.ExitCode -ne 0) {
    Write-Error "Unity scene validation failed with exit code $($process.ExitCode). Log: $logPath"
}

Get-Content -LiteralPath $resolvedReport
