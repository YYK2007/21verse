param(
    [string] $Repository = "YYK2007/21verse_opensource",
    [string] $OutputPath = (Join-Path $PSScriptRoot "..\docs\inventory\github-release-state.csv")
)

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
$resolvedOutput = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputPath)

function Get-GitHubToken {
    $credentialQuery = "protocol=https`nhost=github.com`n`n"
    $credentialText = $credentialQuery | git credential fill
    $passwordLine = $credentialText | Where-Object { $_ -like "password=*" } | Select-Object -First 1

    if (-not $passwordLine) {
        throw "No GitHub credential was returned by git credential fill."
    }

    return ($passwordLine -replace "^password=", "")
}

function Add-StateRow {
    param(
        [System.Collections.Generic.List[object]] $Rows,
        [string] $Area,
        [string] $Setting,
        [string] $Status,
        [string] $Evidence
    )

    $Rows.Add([PSCustomObject]@{
        area = $Area
        setting = $Setting
        status = $Status
        evidence = $Evidence
    }) | Out-Null
}

function Expand-List {
    param([object] $Value)

    if ($Value -is [System.Array]) {
        foreach ($item in $Value) {
            $item
        }
        return
    }

    $Value
}

Push-Location $repoRoot
try {
    $token = Get-GitHubToken
    $headers = @{
        Authorization = "Bearer $token"
        Accept = "application/vnd.github+json"
        "X-GitHub-Api-Version" = "2022-11-28"
        "User-Agent" = "Codex-21Verse-Release-State"
    }

    $rows = [System.Collections.Generic.List[object]]::new()
    $localHead = (git rev-parse HEAD).Trim()
    $remoteHead = (git ls-remote --heads origin main | ForEach-Object { ($_ -split "\s+")[0] } | Select-Object -First 1)
    Add-StateRow $rows "git" "local_head" ($(if ($localHead -eq $remoteHead) { "complete" } else { "mismatch" })) "local=$localHead; origin/main=$remoteHead"

    $repo = Invoke-RestMethod -Method Get -Uri "https://api.github.com/repos/$Repository" -Headers $headers
    Add-StateRow $rows "repository" "visibility" ($(if ($repo.private) { "private" } else { "public" })) "private=$($repo.private)"
    Add-StateRow $rows "repository" "default_branch" ($(if ($repo.default_branch -eq "main") { "complete" } else { "mismatch" })) "default_branch=$($repo.default_branch)"
    Add-StateRow $rows "repository" "issues_enabled" ($(if ($repo.has_issues) { "complete" } else { "missing" })) "has_issues=$($repo.has_issues)"
    Add-StateRow $rows "repository" "projects_disabled" ($(if (-not $repo.has_projects) { "complete" } else { "unexpected" })) "has_projects=$($repo.has_projects)"
    Add-StateRow $rows "repository" "wiki_disabled" ($(if (-not $repo.has_wiki) { "complete" } else { "unexpected" })) "has_wiki=$($repo.has_wiki)"

    $topics = Invoke-RestMethod -Method Get -Uri "https://api.github.com/repos/$Repository/topics" -Headers $headers
    Add-StateRow $rows "repository" "topics" "complete" (($topics.names | Sort-Object) -join "; ")

    $milestonesResponse = Invoke-RestMethod -Method Get -Uri "https://api.github.com/repos/$Repository/milestones?state=open&per_page=20" -Headers $headers
    $milestones = @(Expand-List $milestonesResponse)
    $releaseMilestone = $milestones | Where-Object { $_.title -eq "Public release readiness" } | Select-Object -First 1
    Add-StateRow $rows "milestone" "public_release_readiness" ($(if ($releaseMilestone) { "open" } else { "missing" })) ($(if ($releaseMilestone) { "number=$($releaseMilestone.number); open_issues=$($releaseMilestone.open_issues)" } else { "not found" }))

    $openIssuesResponse = Invoke-RestMethod -Method Get -Uri "https://api.github.com/repos/$Repository/issues?state=open&per_page=100" -Headers $headers
    $openIssues = @(Expand-List $openIssuesResponse)
    foreach ($issueNumber in @(1, 2, 3, 5)) {
        $issue = $openIssues | Where-Object { $_.number -eq $issueNumber } | Select-Object -First 1
        if ($issue) {
            $labels = @($issue.labels | ForEach-Object { $_.name } | Sort-Object) -join "; "
            Add-StateRow $rows "issue" "#$issueNumber" "open" "title=$($issue.title); labels=$labels; milestone=$($issue.milestone.title)"
        }
        else {
            Add-StateRow $rows "issue" "#$issueNumber" "missing" "Required release tracker issue is not open."
        }
    }

    $runs = Invoke-RestMethod -Method Get -Uri "https://api.github.com/repos/$Repository/actions/runs?per_page=20" -Headers $headers
    $headRun = @($runs.workflow_runs | Where-Object { $_.name -eq "Repo Hygiene" -and $_.head_sha -eq $localHead } | Select-Object -First 1)
    if ($headRun) {
        Add-StateRow $rows "actions" "repo_hygiene_head" ($(if ($headRun.status -eq "completed" -and $headRun.conclusion -eq "success") { "success" } else { "not_success" })) "status=$($headRun.status); conclusion=$($headRun.conclusion); sha=$localHead"
    }
    else {
        Add-StateRow $rows "actions" "repo_hygiene_head" "missing" "No Repo Hygiene run found for $localHead."
    }

    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $resolvedOutput) | Out-Null
    $rows | Export-Csv -LiteralPath $resolvedOutput -NoTypeInformation
    Write-Output $resolvedOutput
}
finally {
    Pop-Location
}
