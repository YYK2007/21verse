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
        ".github/ISSUE_TEMPLATE/asset-release-review.md",
        ".github/ISSUE_TEMPLATE/nas-review.md",
        ".github/ISSUE_TEMPLATE/release-gate.md",
        ".github/workflows/repo-hygiene.yml",
        "docs/release-readiness.md",
        "docs/public-release-runbook.md",
        "docs/nas-review-runbook.md",
        "docs/repository-maintenance.md",
        "docs/github-metadata.md",
        "docs/github-tracker.md",
        "docs/inventory/release-audit.md",
        "docs/inventory/google-drive-21verse.csv",
        "docs/inventory/google-drive-release-plan.csv",
        "docs/inventory/unity-asset-audit.csv",
        "docs/inventory/unity-risky-asset-references.csv",
        "tools/run-release-audit.ps1",
        "tools/export-nas-inventory.ps1",
        "tools/run-unity-scene-validation.ps1"
    )

    foreach ($path in $requiredFiles) {
        if (-not (Test-Path -LiteralPath $path)) {
            Add-Failure "Missing required handoff file: $path"
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

    $csvExpectations = @{
        "docs/inventory/google-drive-21verse.csv" = 1
        "docs/inventory/google-drive-release-plan.csv" = 1
        "docs/inventory/unity-asset-audit.csv" = 18
        "docs/inventory/unity-risky-asset-references.csv" = 9
        "docs/inventory/unity-projects.csv" = 1
    }

    foreach ($entry in $csvExpectations.GetEnumerator()) {
        if (Test-Path -LiteralPath $entry.Key) {
            $rows = @(Import-Csv -LiteralPath $entry.Key)
            if ($rows.Count -lt $entry.Value) {
                Add-Failure "CSV $($entry.Key) has $($rows.Count) rows; expected at least $($entry.Value)."
            }
        }
    }

    $trackedGenerated = @(git ls-files |
        Where-Object { $_ -match '(^|/)(Library|Temp|Logs|Obj|Build|Builds|UserSettings)(/|$)' })
    if ($trackedGenerated.Count -gt 0) {
        Add-Failure "Unity generated folders are tracked: $($trackedGenerated -join ', ')"
    }

    $releaseAudit = if (Test-Path -LiteralPath "docs/inventory/release-audit.md") {
        Get-Content -LiteralPath "docs/inventory/release-audit.md" -Raw
    }
    else {
        ""
    }

    if ($releaseAudit -notmatch "Summary:") {
        Add-Failure "Release audit snapshot is missing a Summary line."
    }

    if ($releaseAudit -notmatch "NAS review" -or $releaseAudit -notmatch "Unity third-party asset release decisions") {
        Add-Failure "Release audit snapshot does not mention the known remaining release blockers."
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
