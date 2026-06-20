param(
    [string] $Repository = "YYK2007/21verse_opensource",
    [string] $Branch = "main",
    [string] $OutputPath = (Join-Path $PSScriptRoot "..\docs\inventory\github-branch-protection-status.csv")
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

function New-StatusRow {
    param(
        [string] $Setting,
        [string] $Status,
        [string] $Evidence,
        [string] $NextAction
    )

    [PSCustomObject]@{
        setting = $Setting
        status = $Status
        evidence = $Evidence
        next_action = $NextAction
    }
}

Push-Location $repoRoot
try {
    $token = Get-GitHubToken
    $headers = @{
        Authorization = "Bearer $token"
        Accept = "application/vnd.github+json"
        "X-GitHub-Api-Version" = "2022-11-28"
        "User-Agent" = "Codex-21Verse-Branch-Protection"
    }

    $rows = [System.Collections.Generic.List[object]]::new()
    $uri = "https://api.github.com/repos/$Repository/branches/$Branch/protection"

    try {
        $protection = Invoke-RestMethod -Method Get -Uri $uri -Headers $headers
        $rows.Add((New-StatusRow "main_protection_endpoint" "complete" "GitHub branch protection endpoint returned 200 OK for $Branch." "Keep branch protection enabled through public release.")) | Out-Null

        $requiresPullRequests = $null -ne $protection.required_pull_request_reviews
        $rows.Add((New-StatusRow "pull_request_required" ($(if ($requiresPullRequests) { "complete" } else { "missing" })) ($(if ($requiresPullRequests) { "required_pull_request_reviews is configured." } else { "required_pull_request_reviews is not configured." })) "Require pull requests before merging to main.")) | Out-Null

        $contexts = @()
        if ($protection.required_status_checks -and $protection.required_status_checks.contexts) {
            $contexts = @($protection.required_status_checks.contexts)
        }
        $repoHygieneRequired = $contexts -contains "Repo Hygiene"
        $rows.Add((New-StatusRow "repo_hygiene_required" ($(if ($repoHygieneRequired) { "complete" } else { "missing" })) ($(if ($contexts.Count -gt 0) { "Required contexts: " + ($contexts -join "; ") } else { "No required status-check contexts returned." })) "Require the Repo Hygiene status check before merge.")) | Out-Null

        $allowsForcePushes = $false
        if ($protection.allow_force_pushes -and $null -ne $protection.allow_force_pushes.enabled) {
            $allowsForcePushes = [bool]$protection.allow_force_pushes.enabled
        }
        $rows.Add((New-StatusRow "force_pushes_disabled" ($(if (-not $allowsForcePushes) { "complete" } else { "missing" })) ($(if (-not $allowsForcePushes) { "allow_force_pushes is disabled." } else { "allow_force_pushes is enabled." })) "Confirm force pushes are disabled on main.")) | Out-Null

        $allowsDeletions = $false
        if ($protection.allow_deletions -and $null -ne $protection.allow_deletions.enabled) {
            $allowsDeletions = [bool]$protection.allow_deletions.enabled
        }
        $rows.Add((New-StatusRow "branch_deletions_disabled" ($(if (-not $allowsDeletions) { "complete" } else { "missing" })) ($(if (-not $allowsDeletions) { "allow_deletions is disabled." } else { "allow_deletions is enabled." })) "Confirm branch deletion is disabled on main.")) | Out-Null
    }
    catch {
        $statusCode = $null
        if ($_.Exception.Response) {
            $statusCode = [int]$_.Exception.Response.StatusCode
        }

        $message = ($_.Exception.Message -replace "\s+", " ").Trim()
        $endpointEvidence = if ($statusCode) {
            "GitHub API returned $statusCode for GET /repos/$Repository/branches/$Branch/protection: $message"
        }
        else {
            "GitHub branch protection probe failed: $message"
        }

        $rows.Add((New-StatusRow "main_protection_endpoint" "blocked" $endpointEvidence "Verify branch protection from a GitHub admin session.")) | Out-Null
        $rows.Add((New-StatusRow "pull_request_required" "pending_admin_verification" "Not inspected from this session." "Require pull requests before merging to main.")) | Out-Null
        $rows.Add((New-StatusRow "repo_hygiene_required" "pending_admin_verification" "Not inspected from this session." "Require the Repo Hygiene status check before merge.")) | Out-Null
        $rows.Add((New-StatusRow "force_pushes_disabled" "pending_admin_verification" "Not inspected from this session." "Confirm force pushes are disabled on main.")) | Out-Null
        $rows.Add((New-StatusRow "branch_deletions_disabled" "pending_admin_verification" "Not inspected from this session." "Confirm branch deletion is disabled on main.")) | Out-Null
    }

    $outputDir = Split-Path -Parent $resolvedOutput
    New-Item -ItemType Directory -Force -Path $outputDir | Out-Null
    $rows | Export-Csv -LiteralPath $resolvedOutput -NoTypeInformation
    Write-Output $resolvedOutput
}
finally {
    Pop-Location
}
