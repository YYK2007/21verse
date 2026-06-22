param(
    [string] $InventoryPath = (Join-Path $PSScriptRoot "..\docs\inventory\google-drive-21verse.csv"),
    [string] $OutputPath = (Join-Path $PSScriptRoot "..\docs\inventory\google-drive-release-plan.csv")
)

$ErrorActionPreference = "Stop"

$resolvedInventory = (Resolve-Path -LiteralPath $InventoryPath).Path
$resolvedOutput = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputPath)
$rows = @(Import-Csv -LiteralPath $resolvedInventory)

$planRows = foreach ($row in $rows) {
    $classification = ""
    if ($row.classification) {
        $classification = $row.classification.ToLowerInvariant()
    }

    $action = ""
    if ($row.repo_action) {
        $action = $row.repo_action.ToLowerInvariant()
    }

    $decision = "review_before_export"
    $publicCandidate = "maybe"
    $reason = "Needs manual public-release review."

    if ($classification -match "irb|testing|pilot|financial|investor|partner|vendor|outreach|strategy|roadmap|research participant" -or
        $action -match "private only|do not export|likely sensitive") {
        $decision = "exclude_private"
        $publicCandidate = "no"
        $reason = "Contains or likely contains private research, business, partner, investor, testing, financial, or outreach material."
    }
    elseif ($action -match "sanitized summary included") {
        $decision = "already_summarized"
        $publicCandidate = "yes"
        $reason = "A sanitized derivative is already present in the repo."
    }
    elseif ($action -match "local pdf already included") {
        $decision = "already_included"
        $publicCandidate = "yes"
        $reason = "A local public-facing export is already staged in the repo."
    }
    elseif ($classification -match "public-facing|conference|event|poster|showcase" -or
        $action -match "possible public|review before export|public export requires review") {
        $decision = "sanitize_then_export_candidate"
        $publicCandidate = "yes_after_review"
        $reason = "Potential public collateral, but requires redaction and owner review before export."
    }
    elseif ($classification -match "game design document|literature review|sample testing data|project planning") {
        $decision = "summarize_or_redact"
        $publicCandidate = "maybe"
        $reason = "May be useful as public documentation only after citation, anonymization, or redaction."
    }

    [PSCustomObject]@{
        type = $row.type
        title = $row.title
        classification = $row.classification
        current_repo_action = $row.repo_action
        public_release_decision = $decision
        public_candidate = $publicCandidate
        reason = $reason
    }
}

$outputDir = Split-Path -Parent $resolvedOutput
New-Item -ItemType Directory -Force -Path $outputDir | Out-Null
$tempOutput = Join-Path $env:TEMP ("google-drive-release-plan-" + [guid]::NewGuid().ToString("N") + ".csv")
$planRows | Export-Csv -LiteralPath $tempOutput -NoTypeInformation

if (Test-Path -LiteralPath $resolvedOutput) {
    $existingText = Get-Content -LiteralPath $resolvedOutput -Raw
    $newText = Get-Content -LiteralPath $tempOutput -Raw
    if ($existingText -eq $newText) {
        Remove-Item -LiteralPath $tempOutput -Force
        Write-Output $resolvedOutput
        return
    }
}

Move-Item -LiteralPath $tempOutput -Destination $resolvedOutput -Force
Write-Output $resolvedOutput
