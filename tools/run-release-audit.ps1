param(
    [string] $OutputPath = (Join-Path $PSScriptRoot "..\docs\inventory\release-audit.md")
)

$ErrorActionPreference = "Stop"

function Add-Gate {
    param(
        [System.Collections.Generic.List[object]] $Gates,
        [string] $Name,
        [string] $Status,
        [string] $Evidence,
        [string] $NextStep = ""
    )

    $Gates.Add([PSCustomObject]@{
        Name = $Name
        Status = $Status
        Evidence = $Evidence
        NextStep = $NextStep
    }) | Out-Null
}

$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
$resolvedOutput = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputPath)
Push-Location $repoRoot

try {
    $gates = [System.Collections.Generic.List[object]]::new()
    $gitStatus = @(git status --short --branch -- . ":(exclude)docs/inventory/release-audit.md")
    $isClean = ($gitStatus.Count -eq 1 -and $gitStatus[0] -match '^## main\.\.\.origin/main( \[.*\])?$')
    Add-Gate $gates "Git working tree" ($(if ($isClean) { "pass" } else { "blocker" })) ($gitStatus -join " | ") "Commit, discard, or document all local changes."

    $remoteHead = git ls-remote --heads origin main
    Add-Gate $gates "GitHub remote main" ($(if ($remoteHead) { "pass" } else { "blocker" })) $remoteHead "Restore origin/main tracking."

    $largeFiles = @(Get-ChildItem -Recurse -Force -File |
        Where-Object {
            $_.FullName -notmatch '\\.git\\' -and
            $_.FullName -notmatch '\\Library\\' -and
            $_.FullName -notmatch '\\Temp\\' -and
            $_.FullName -notmatch '\\Logs\\' -and
            $_.Length -gt 100MB
        })
    Add-Gate $gates "Non-LFS >100 MB file check" ($(if ($largeFiles.Count -eq 0) { "pass" } else { "blocker" })) ($(if ($largeFiles.Count -eq 0) { "No non-generated files over 100 MB found." } else { ($largeFiles | ForEach-Object { "$($_.FullName) ($($_.Length) bytes)" }) -join "; " })) "Move oversized files to Git LFS or remove them."

    $secretMatches = @(rg -n --hidden -S "(api[_-]?key|secret|password|passwd|token|client_secret|private_key|BEGIN RSA|BEGIN PRIVATE|ghp_|AIza|sk-[A-Za-z0-9])" --glob "!.git/**" --glob "!docs/inventory/generated/**" --glob "!docs/inventory/release-audit.md" --glob "!tools/run-release-audit.ps1" --glob "!tools/test-repo-hygiene.ps1" . 2>$null)
    $unexpectedSecrets = @($secretMatches | Where-Object {
        $_ -notmatch '^\.\\\.gitignore:' -and
        $_ -notmatch '^\.\\SECURITY\.md:' -and
        $_ -notmatch '^\.\\docs\\release-readiness\.md:' -and
        $_ -notmatch '^\.\\docs\\inventory\\nas-access-log\.csv:'
    })
    Add-Gate $gates "Secret scan" ($(if ($unexpectedSecrets.Count -eq 0) { "pass" } else { "blocker" })) ($(if ($unexpectedSecrets.Count -eq 0) { "Only expected documentation matches found." } else { $unexpectedSecrets -join "; " })) "Investigate and remove any real secret material."

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
        "docs/open-source-review.md",
        "docs/source-inventory.md",
        "docs/google-drive-inventory.md",
        "docs/google-drive-release-plan.md",
        "docs/design-and-nas-inventory.md",
        "docs/game-design-summary.md",
        "docs/third-party-assets.md",
        "docs/unity-dependencies.md",
        "docs/unity-validation.md",
        "docs/release-readiness.md",
        "docs/public-release-runbook.md",
        "docs/nas-review-runbook.md",
        "docs/repository-maintenance.md",
        "docs/github-private-repo.md",
        "docs/github-metadata.md",
        "docs/github-tracker.md",
        "docs/inventory/google-drive-21verse.csv",
        "docs/inventory/google-drive-release-plan.csv",
        "docs/inventory/local-design-summary.csv",
        "docs/inventory/nas-access-log.csv",
        "docs/inventory/unity-asset-audit.csv",
        "docs/inventory/unity-risky-asset-references.csv",
        "docs/inventory/unity-projects.csv",
        "tools/export-nas-inventory.ps1"
    )
    $missingFiles = @($requiredFiles | Where-Object { -not (Test-Path -LiteralPath $_) })
    Add-Gate $gates "Required handoff docs" ($(if ($missingFiles.Count -eq 0) { "pass" } else { "blocker" })) ($(if ($missingFiles.Count -eq 0) { "All expected handoff docs and inventories are present." } else { "Missing: " + ($missingFiles -join ", ") })) "Restore missing docs."

    $sceneValidator = Test-Path -LiteralPath "tools/run-unity-scene-validation.ps1"
    $unityValidation = Select-String -LiteralPath "docs/unity-validation.md" -Pattern "zero missing script references" -Quiet
    Add-Gate $gates "Unity batchmode scene validation" ($(if ($sceneValidator -and $unityValidation) { "pass" } else { "blocker" })) "Scene validator script present: $sceneValidator; docs record zero missing script references: $unityValidation." "Run tools/run-unity-scene-validation.ps1 and update docs/unity-validation.md."

    $assetAuditRows = @(Import-Csv -LiteralPath "docs/inventory/unity-asset-audit.csv")
    $assetReferenceRows = @(Import-Csv -LiteralPath "docs/inventory/unity-risky-asset-references.csv")
    $assetBlockers = @($assetAuditRows | Where-Object {
        $_.public_release_action -match 'remove|replace|Confirm|Treat as Unity Asset Store|Review sprite ownership|Prefer documenting'
    })
    $referencedRiskyFolders = @($assetReferenceRows | Where-Object { [int]$_.external_reference_count -gt 0 })
    Add-Gate $gates "Unity third-party asset release decisions" "blocker" "$($assetAuditRows.Count) asset folders audited; $($assetBlockers.Count) folders still need rights/replacement decisions; $($referencedRiskyFolders.Count) risky folders have serialized references." "Resolve issue #2 by confirming rights, replacing referenced assets, removing assets, or documenting import steps."

    $nasRows = @(Import-Csv -LiteralPath "docs/inventory/nas-access-log.csv")
    $nasEvidence = ($nasRows | ForEach-Object { "$($_.check): $($_.result)" }) -join "; "
    $nasBlocked = $nasEvidence -match "blocked|password required|no active"
    Add-Gate $gates "NAS review" ($(if ($nasBlocked) { "blocker" } else { "pass" })) "NAS access log records: $nasEvidence" "Mount/authenticate to Youssef Storage / WDMyCloudEX4100 and inventory 21Verse files."

    $driveRows = @(Import-Csv -LiteralPath "docs/inventory/google-drive-21verse.csv")
    Add-Gate $gates "Google Drive inventory" ($(if ($driveRows.Count -gt 0) { "pass" } else { "blocker" })) "$($driveRows.Count) Google Drive rows inventoried." "Only export public-safe, redacted docs/decks when selected."

    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add("# Release Audit") | Out-Null
    $lines.Add("") | Out-Null
    $lines.Add("Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')") | Out-Null
    $lines.Add("") | Out-Null
    $lines.Add('This audit is a local verification snapshot for the private staging repo. A `blocker` status means the repo must not be made public yet.') | Out-Null
    $lines.Add("") | Out-Null
    $lines.Add("| Gate | Status | Evidence | Next step |") | Out-Null
    $lines.Add("| --- | --- | --- | --- |") | Out-Null

    foreach ($gate in $gates) {
        $evidence = ($gate.Evidence -replace '\|', '/' -replace "`r?`n", " ").Trim()
        $nextStep = ($gate.NextStep -replace '\|', '/' -replace "`r?`n", " ").Trim()
        $lines.Add("| $($gate.Name) | $($gate.Status) | $evidence | $nextStep |") | Out-Null
    }

    $summary = $gates | Group-Object Status | ForEach-Object { "$($_.Name): $($_.Count)" }
    $lines.Add("") | Out-Null
    $lines.Add("Summary: " + ($summary -join "; ")) | Out-Null

    $outputDir = Split-Path -Parent $resolvedOutput
    New-Item -ItemType Directory -Force -Path $outputDir | Out-Null
    Set-Content -LiteralPath $resolvedOutput -Value $lines -Encoding UTF8
    Write-Output $resolvedOutput
}
finally {
    Pop-Location
}
