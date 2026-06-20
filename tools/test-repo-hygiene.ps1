$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
Push-Location $repoRoot

try {
    $failures = [System.Collections.Generic.List[string]]::new()

    function Add-Failure {
        param([string] $Message)
        $failures.Add($Message) | Out-Null
    }

    function ConvertTo-ComparableText {
        param([string] $Text)

        return (($Text.ToLowerInvariant() -replace '[^a-z0-9]+', ' ').Trim() -replace '\s+', ' ')
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
        "docs/release-evidence-manifest.md",
        "docs/public-release-runbook.md",
        "docs/nas-review-runbook.md",
        "docs/nas-review-checklist.md",
        "docs/unity-smoke-test-checklist.md",
        "docs/repository-maintenance.md",
        "docs/github-branch-protection.md",
        "docs/asset-disposition-tracker.md",
        "docs/github-metadata.md",
        "docs/github-tracker.md",
        "docs/inventory/release-audit.md",
        "docs/inventory/github-branch-protection-status.csv",
        "docs/inventory/release-requirements-status.csv",
        "docs/inventory/google-drive-21verse.csv",
        "docs/inventory/google-drive-release-plan.csv",
        "docs/inventory/nas-review-status.csv",
        "docs/inventory/unity-smoke-test-status.csv",
        "docs/inventory/unity-asset-disposition.csv",
        "docs/inventory/unity-asset-audit.csv",
        "docs/inventory/unity-risky-asset-references.csv",
        "tools/test-github-release-state.ps1",
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

    if ($env:GITHUB_EVENT_PATH -and (Test-Path -LiteralPath $env:GITHUB_EVENT_PATH)) {
        $githubEvent = Get-Content -LiteralPath $env:GITHUB_EVENT_PATH -Raw | ConvertFrom-Json
        if ($githubEvent.repository -and $githubEvent.repository.private -ne $true) {
            Add-Failure "GitHub Actions visibility guard failed: repository is public, but release blockers are still tracked."
        }
    }

    $csvExpectations = @{
        "docs/inventory/google-drive-21verse.csv" = 1
        "docs/inventory/google-drive-release-plan.csv" = 1
        "docs/inventory/github-branch-protection-status.csv" = 5
        "docs/inventory/release-requirements-status.csv" = 9
        "docs/inventory/nas-review-status.csv" = 5
        "docs/inventory/unity-smoke-test-status.csv" = 5
        "docs/inventory/unity-asset-audit.csv" = 18
        "docs/inventory/unity-asset-disposition.csv" = 9
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

    $requirementRows = @(Import-Csv -LiteralPath "docs/inventory/release-requirements-status.csv")
    $manifest = Get-Content -LiteralPath "docs/release-evidence-manifest.md" -Raw
    $comparableManifest = ConvertTo-ComparableText $manifest
    $allowedRequirementStatuses = @(
        "complete",
        "blocked",
        "complete_inventory_pending_exports",
        "complete_ongoing"
    )

    foreach ($row in $requirementRows) {
        if ([string]::IsNullOrWhiteSpace($row.requirement)) {
            Add-Failure "Release requirement row has an empty requirement name."
            continue
        }

        if ($allowedRequirementStatuses -notcontains $row.status) {
            Add-Failure "Release requirement '$($row.requirement)' has unexpected status '$($row.status)'."
        }

        $comparableRequirement = ConvertTo-ComparableText $row.requirement
        if (-not $comparableManifest.Contains($comparableRequirement)) {
            Add-Failure "Release requirement '$($row.requirement)' is missing from docs/release-evidence-manifest.md."
        }

        if ($row.status -eq "blocked" -and [string]::IsNullOrWhiteSpace($row.issue)) {
            Add-Failure "Blocked release requirement '$($row.requirement)' is not linked to a tracker issue."
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
