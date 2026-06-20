param(
    [string] $ReleasePlanPath = (Join-Path $PSScriptRoot "..\docs\inventory\google-drive-release-plan.csv"),
    [string] $OutputPath = (Join-Path $PSScriptRoot "..\docs\inventory\google-drive-public-manifest.csv")
)

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
$resolvedOutput = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputPath)

function Get-ExportGate {
    param([string] $Decision)

    switch ($Decision) {
        "exclude_private" { "keep_private_no_public_export" }
        "already_included" { "already_staged_public_derivative" }
        "already_summarized" { "already_staged_sanitized_summary" }
        "sanitize_then_export_candidate" { "sanitize_and_owner_review_before_export" }
        "summarize_or_redact" { "summarize_or_redact_before_export" }
        "review_before_export" { "manual_review_before_export" }
        default { "manual_review_before_export" }
    }
}

function Get-LocalArtifact {
    param(
        [string] $Title,
        [string] $Decision
    )

    if ($Decision -eq "already_included" -and $Title -eq "Poster 2 for 21Verse") {
        return "docs/poster-2.pdf"
    }

    if ($Decision -eq "already_summarized" -and $Title -eq "21Verse Game Design Document [May 2024]") {
        return "docs/game-design-summary.md"
    }

    return ""
}

Push-Location $repoRoot
try {
    $releaseRows = @(Import-Csv -LiteralPath $ReleasePlanPath)
    $manifestRows = foreach ($row in $releaseRows) {
        $decision = $row.public_release_decision
        $gate = Get-ExportGate -Decision $decision
        $localArtifact = Get-LocalArtifact -Title $row.title -Decision $decision

        [PSCustomObject]@{
            type = $row.type
            title = $row.title
            public_release_decision = $decision
            export_gate = $gate
            public_candidate = $row.public_candidate
            local_public_artifact = $localArtifact
            required_review = if ($gate -match "sanitize|redact|manual") { "owner_review_and_redaction" } elseif ($gate -match "keep_private") { "none_keep_private" } else { "verify_staged_artifact" }
            private_material_rule = if ($decision -eq "exclude_private") { "Do not export to the public repo." } else { "Export only a sanitized derivative after review." }
            reason = $row.reason
            url = $row.url
        }
    }

    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $resolvedOutput) | Out-Null
    $manifestRows | Export-Csv -LiteralPath $resolvedOutput -NoTypeInformation
    Write-Output $resolvedOutput
}
finally {
    Pop-Location
}
