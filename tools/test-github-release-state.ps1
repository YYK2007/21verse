param(
    [string] $Repository = "YYK2007/21verse_opensource",
    [string] $ExpectedDescription = "Private staging repository for preparing 21Verse for open-source release"
)

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
Push-Location $repoRoot

try {
    $failures = [System.Collections.Generic.List[string]]::new()

    function Add-Failure {
        param([string] $Message)
        $failures.Add($Message) | Out-Null
    }

    function Get-GitHubToken {
        $credentialQuery = "protocol=https`nhost=github.com`n`n"
        $credentialText = $credentialQuery | git credential fill
        $passwordLine = $credentialText | Where-Object { $_ -like "password=*" } | Select-Object -First 1

        if (-not $passwordLine) {
            throw "No GitHub credential was returned by git credential fill."
        }

        return ($passwordLine -replace "^password=", "")
    }

    function Invoke-GitHubApi {
        param(
            [string] $Method,
            [string] $Uri,
            [hashtable] $Headers
        )

        $response = Invoke-RestMethod -Method $Method -Uri $Uri -Headers $Headers
        if ($response -is [System.Array]) {
            foreach ($item in $response) {
                $item
            }
            return
        }

        return $response
    }

    $token = Get-GitHubToken
    $headers = @{
        Authorization = "Bearer $token"
        Accept = "application/vnd.github+json"
        "X-GitHub-Api-Version" = "2022-11-28"
        "User-Agent" = "Codex-21Verse-Release-State"
    }

    $localStatus = @(git status --short --branch)
    $isSyncedMain = $localStatus.Count -eq 1 -and $localStatus[0] -eq "## main...origin/main"
    if (-not $isSyncedMain) {
        Add-Failure "Local branch is not clean and synced with origin/main: $($localStatus -join ' | ')"
    }

    $localHead = (git rev-parse HEAD).Trim()
    $remoteHead = (git ls-remote --heads origin main | ForEach-Object { ($_ -split "\s+")[0] } | Select-Object -First 1)
    if ($localHead -ne $remoteHead) {
        Add-Failure "Local HEAD $localHead does not match origin/main $remoteHead."
    }

    $repo = Invoke-GitHubApi -Method Get -Uri "https://api.github.com/repos/$Repository" -Headers $headers
    if (-not $repo.private) {
        Add-Failure "GitHub repository is not private."
    }
    if ($repo.default_branch -ne "main") {
        Add-Failure "GitHub default branch is '$($repo.default_branch)', expected 'main'."
    }
    if ($repo.description -ne $ExpectedDescription) {
        Add-Failure "GitHub description is '$($repo.description)', expected '$ExpectedDescription'."
    }
    if (-not $repo.has_issues) {
        Add-Failure "GitHub issues are not enabled."
    }
    if ($repo.has_projects) {
        Add-Failure "GitHub projects are enabled; expected disabled."
    }
    if ($repo.has_wiki) {
        Add-Failure "GitHub wiki is enabled; expected disabled."
    }

    $expectedTopics = @(
        "21verse",
        "accessibility",
        "education",
        "open-source-staging",
        "unity",
        "virtual-reality"
    )
    $topicsResponse = Invoke-GitHubApi -Method Get -Uri "https://api.github.com/repos/$Repository/topics" -Headers $headers
    $actualTopics = @($topicsResponse.names | Sort-Object)
    foreach ($topic in $expectedTopics) {
        if ($actualTopics -notcontains $topic) {
            Add-Failure "GitHub topic '$topic' is missing."
        }
    }

    $expectedLabels = @{
        "blocker" = "Must be resolved before public release"
        "open-source-readiness" = "Work required for future public open-source release"
        "licensing" = "Licensing, attribution, or redistribution rights review"
        "nas" = "Youssef Storage / WDMyCloudEX4100 inventory and review"
        "unity" = "Unity project, scenes, packages, or assets"
        "validation" = "Validation, smoke testing, or release audit work"
    }
    $labels = @(Invoke-GitHubApi -Method Get -Uri "https://api.github.com/repos/$Repository/labels?per_page=100" -Headers $headers)
    foreach ($entry in $expectedLabels.GetEnumerator()) {
        $label = $labels | Where-Object { $_.name -eq $entry.Key } | Select-Object -First 1
        if (-not $label) {
            Add-Failure "GitHub label '$($entry.Key)' is missing."
            continue
        }

        if ($label.description -ne $entry.Value) {
            Add-Failure "GitHub label '$($entry.Key)' has description '$($label.description)', expected '$($entry.Value)'."
        }
    }

    $milestone = Invoke-GitHubApi -Method Get -Uri "https://api.github.com/repos/$Repository/milestones/1" -Headers $headers
    if ($milestone.title -ne "Public release readiness" -or $milestone.state -ne "open") {
        Add-Failure "Public release readiness milestone is not open as expected."
    }

    $expectedIssueLabels = @{
        1 = @("blocker", "nas", "open-source-readiness")
        2 = @("blocker", "licensing", "open-source-readiness")
        3 = @("blocker", "open-source-readiness", "unity", "validation")
    }
    $expectedIssueBodySnippets = @{
        1 = @(
            "docs/design-and-nas-inventory.md",
            "docs/nas-review-checklist.md",
            "docs/inventory/nas-review-status.csv"
        )
        2 = @(
            "docs/third-party-assets.md",
            "docs/asset-disposition-tracker.md",
            "docs/inventory/unity-asset-disposition.csv"
        )
        3 = @(
            "docs/unity-validation.md",
            "docs/unity-smoke-test-checklist.md",
            "docs/inventory/unity-smoke-test-status.csv"
        )
    }
    $openIssues = @(Invoke-GitHubApi -Method Get -Uri "https://api.github.com/repos/$Repository/issues?state=open&per_page=50" -Headers $headers)
    foreach ($issueNumber in @(1, 2, 3)) {
        $issue = $openIssues | Where-Object { $_.number -eq $issueNumber } | Select-Object -First 1
        if (-not $issue) {
            Add-Failure "Required release tracker issue #$issueNumber is not open."
            continue
        }

        if ($issue.milestone.number -ne 1) {
            Add-Failure "Release tracker issue #$issueNumber is not assigned to milestone 1."
        }

        $actualIssueLabels = @($issue.labels | ForEach-Object { $_.name })
        foreach ($expectedLabel in $expectedIssueLabels[$issueNumber]) {
            if ($actualIssueLabels -notcontains $expectedLabel) {
                Add-Failure "Release tracker issue #$issueNumber is missing label '$expectedLabel'."
            }
        }

        foreach ($snippet in $expectedIssueBodySnippets[$issueNumber]) {
            if ($issue.body -notlike "*$snippet*") {
                Add-Failure "Release tracker issue #$issueNumber body is missing evidence reference '$snippet'."
            }
        }
    }

    $runs = Invoke-GitHubApi -Method Get -Uri "https://api.github.com/repos/$Repository/actions/runs?per_page=20" -Headers $headers
    $headRun = @($runs.workflow_runs | Where-Object { $_.name -eq "Repo Hygiene" -and $_.head_sha -eq $localHead } | Select-Object -First 1)
    if (-not $headRun) {
        Add-Failure "No Repo Hygiene Actions run found for local HEAD $localHead."
    }
    elseif ($headRun.status -ne "completed" -or $headRun.conclusion -ne "success") {
        Add-Failure "Repo Hygiene run for $localHead is $($headRun.status) / $($headRun.conclusion)."
    }

    if ($failures.Count -gt 0) {
        $failures | ForEach-Object { Write-Error $_ }
        exit 1
    }

    Write-Output "GitHub release-state checks passed for $Repository at $localHead."
}
finally {
    Pop-Location
}
