$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
Push-Location $repoRoot

try {
    $failures = [System.Collections.Generic.List[string]]::new()

    function Add-Failure {
        param([string] $Message)
        $failures.Add($Message) | Out-Null
    }

    $requiredFiles = @(
        "README.md",
        "LICENSE",
        "NOTICE.md",
        "CONTRIBUTING.md",
        "SECURITY.md",
        "CODE_OF_CONDUCT.md",
        "SUPPORT.md",
        "CHANGELOG.md",
        ".github/PULL_REQUEST_TEMPLATE.md",
        ".github/CODEOWNERS",
        ".github/dependabot.yml",
        ".github/ISSUE_TEMPLATE/config.yml",
        ".github/ISSUE_TEMPLATE/bug_report.md",
        ".github/ISSUE_TEMPLATE/documentation.md",
        ".github/workflows/repo-hygiene.yml",
        "docs/game-design-summary.md",
        "docs/unity-validation.md",
        "docs/unity-dependencies.md",
        "docs/third-party-assets.md",
        "docs/repository-maintenance.md",
        "docs/github-metadata.md",
        "tools/test-repo-hygiene.ps1",
        "tools/run-unity-scene-validation.ps1",
        "unity/21verse-vr-game-hub/Packages/manifest.json",
        "unity/21verse-vr-game-hub/Packages/packages-lock.json",
        "unity/21verse-vr-game-hub/ProjectSettings/ProjectVersion.txt"
    )

    foreach ($path in $requiredFiles) {
        if (-not (Test-Path -LiteralPath $path)) {
            Add-Failure "Missing required file: $path"
        }
    }

    foreach ($script in Get-ChildItem -LiteralPath "tools" -Filter *.ps1 -File) {
        $parseTokens = $null
        $errors = $null
        [System.Management.Automation.Language.Parser]::ParseFile($script.FullName, [ref] $parseTokens, [ref] $errors) | Out-Null
        if ($errors.Count -gt 0) {
            Add-Failure "PowerShell parse errors in $($script.FullName): $($errors -join '; ')"
        }
    }

    $trackedFiles = @(git ls-files)
    $trackedGenerated = @($trackedFiles |
        Where-Object { $_ -match '(^|/)(Library|Temp|Logs|Obj|Build|Builds|UserSettings)(/|$)' })
    if ($trackedGenerated.Count -gt 0) {
        Add-Failure "Unity generated folders are tracked: $($trackedGenerated -join ', ')"
    }

    $largeFiles = @()
    foreach ($path in $trackedFiles) {
        if (Test-Path -LiteralPath $path) {
            $item = Get-Item -LiteralPath $path
            if ($item.Length -gt 100MB) {
                $largeFiles += "$path ($($item.Length) bytes)"
            }
        }
    }
    if ($largeFiles.Count -gt 0) {
        Add-Failure "Tracked files over 100 MB found: $($largeFiles -join ', ')"
    }

    $secretPattern = '(ghp_[A-Za-z0-9_]{20,}|sk-[A-Za-z0-9]{20,}|AIza[0-9A-Za-z_-]{20,}|(api[_-]?key|client_secret|password)[[:space:]]*[:=][[:space:]]*[''"]?[A-Za-z0-9_./=+-]{12,})'
    if (Get-Command rg -ErrorAction SilentlyContinue) {
        $secretMatches = @(rg -n --hidden -S $secretPattern --glob "!.git/**" --glob "!tools/test-repo-hygiene.ps1" . 2>$null)
    }
    else {
        $secretMatches = @(git grep -n -I -E $secretPattern -- . ":(exclude)tools/test-repo-hygiene.ps1" 2>$null)
    }
    if ($secretMatches.Count -gt 0) {
        Add-Failure "Potential secret material found: $($secretMatches -join '; ')"
    }

    $unityVersion = Get-Content -LiteralPath "unity/21verse-vr-game-hub/ProjectSettings/ProjectVersion.txt" -Raw
    if ($unityVersion -notmatch "2022\.3\.25f1") {
        Add-Failure "Unity project version is not 2022.3.25f1."
    }

    if ($failures.Count -gt 0) {
        $failures | ForEach-Object { Write-Error $_ }
        exit 1
    }

    Write-Output "Repository hygiene checks passed."
}
finally {
    Pop-Location
}
