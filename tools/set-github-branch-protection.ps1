param(
    [string] $Repository = "YYK2007/21verse_opensource",
    [string] $Branch = "main",
    [string] $RequiredStatusContext = "Repository hygiene",
    [switch] $Apply
)

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path

function Get-GitHubToken {
    $credentialQuery = "protocol=https`nhost=github.com`n`n"
    $credentialText = $credentialQuery | git credential fill
    $passwordLine = $credentialText | Where-Object { $_ -like "password=*" } | Select-Object -First 1

    if (-not $passwordLine) {
        throw "No GitHub credential was returned by git credential fill."
    }

    return ($passwordLine -replace "^password=", "")
}

Push-Location $repoRoot
try {
    $body = @{
        required_status_checks = @{
            strict = $true
            contexts = @($RequiredStatusContext)
        }
        enforce_admins = $false
        required_pull_request_reviews = @{
            dismiss_stale_reviews = $true
            require_code_owner_reviews = $true
            required_approving_review_count = 1
        }
        restrictions = $null
        required_conversation_resolution = $true
        allow_force_pushes = $false
        allow_deletions = $false
    }

    $payload = $body | ConvertTo-Json -Depth 8

    if (-not $Apply) {
        Write-Output "Dry run only. Re-run with -Apply from a GitHub admin session to configure branch protection."
        Write-Output $payload
        return
    }

    $token = Get-GitHubToken
    $headers = @{
        Authorization = "Bearer $token"
        Accept = "application/vnd.github+json"
        "X-GitHub-Api-Version" = "2022-11-28"
        "User-Agent" = "Codex-21Verse-Branch-Protection"
    }

    $uri = "https://api.github.com/repos/$Repository/branches/$Branch/protection"
    Invoke-RestMethod -Method Put -Uri $uri -Headers $headers -Body $payload -ContentType "application/json" | Out-Null

    Write-Output "Branch protection apply request succeeded for $Repository/$Branch."
    Write-Output "Run .\tools\test-github-branch-protection.ps1 to refresh docs/inventory/github-branch-protection-status.csv."
}
finally {
    Pop-Location
}
