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
    $remoteEvidence = if ($remoteHead) { "origin/main resolved." } else { "origin/main did not resolve." }
    Add-Gate $gates "GitHub remote main" ($(if ($remoteHead) { "pass" } else { "blocker" })) $remoteEvidence "Restore origin/main tracking."

    $largeFiles = @(Get-ChildItem -Recurse -Force -File |
        Where-Object {
            $_.FullName -notmatch '\\.git\\' -and
            $_.FullName -notmatch '\\Library\\' -and
            $_.FullName -notmatch '\\Temp\\' -and
            $_.FullName -notmatch '\\Logs\\' -and
            $_.Length -gt 100MB
        })
    Add-Gate $gates "Non-LFS >100 MB file check" ($(if ($largeFiles.Count -eq 0) { "pass" } else { "blocker" })) ($(if ($largeFiles.Count -eq 0) { "No non-generated files over 100 MB found." } else { ($largeFiles | ForEach-Object { "$($_.FullName) ($($_.Length) bytes)" }) -join "; " })) "Move oversized files to Git LFS or remove them."

    $secretMatches = @(rg -n --hidden -S "(api[_-]?key|secret|password|passwd|token|client_secret|private_key|BEGIN RSA|BEGIN PRIVATE|ghp_|AIza|sk-[A-Za-z0-9])" --glob "!.git/**" --glob "!docs/inventory/generated/**" --glob "!docs/inventory/release-audit.md" --glob "!tools/run-release-audit.ps1" --glob "!tools/test-repo-hygiene.ps1" --glob "!tools/test-github-release-state.ps1" --glob "!tools/export-github-release-state.ps1" --glob "!tools/test-github-branch-protection.ps1" --glob "!tools/set-github-branch-protection.ps1" --glob "!tools/test-nas-access.ps1" . 2>$null)
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
        "docs/asset-disposition-tracker.md",
        "docs/unity-external-imports.md",
        "docs/public-asset-manifest.md",
        "docs/unity-attribution-gap-report.md",
        "docs/third-party-assets.md",
        "docs/unity-dependencies.md",
        "docs/unity-validation.md",
        "docs/release-readiness.md",
        "docs/release-evidence-manifest.md",
        "docs/release-blocker-action-plan.md",
        "docs/public-release-runbook.md",
        "docs/public-release-file-plan.md",
        "docs/google-drive-public-manifest.md",
        "docs/nas-review-runbook.md",
        "docs/nas-review-checklist.md",
        "docs/unity-smoke-test-checklist.md",
        "docs/unity-interactive-smoke-plan.md",
        "docs/repository-maintenance.md",
        "docs/github-branch-protection.md",
        "docs/github-release-state.md",
        "docs/github-private-repo.md",
        "docs/github-metadata.md",
        "docs/github-tracker.md",
        "docs/inventory/google-drive-21verse.csv",
        "docs/inventory/google-drive-release-plan.csv",
        "docs/inventory/google-drive-public-manifest.csv",
        "docs/inventory/public-release-file-plan.csv",
        "docs/inventory/github-release-state.csv",
        "docs/inventory/github-branch-protection-status.csv",
        "docs/inventory/release-blocker-action-plan.csv",
        "docs/inventory/release-requirements-status.csv",
        "docs/inventory/local-design-summary.csv",
        "docs/inventory/nas-access-log.csv",
        "docs/inventory/nas-review-status.csv",
        "docs/inventory/unity-smoke-test-status.csv",
        "docs/inventory/unity-pre-smoke-status.csv",
        "docs/inventory/unity-interactive-smoke-plan.csv",
        "docs/inventory/unity-asset-disposition.csv",
        "docs/inventory/unity-external-imports.csv",
        "docs/inventory/unity-asset-audit.csv",
        "docs/inventory/unity-risky-asset-references.csv",
        "docs/inventory/unity-asset-replacement-worklist.csv",
        "docs/inventory/unity-public-asset-manifest.csv",
        "docs/inventory/unity-attribution-gap-report.csv",
        "docs/inventory/unity-third-party-removal-status.csv",
        "docs/inventory/unity-projects.csv",
        "tools/test-github-release-state.ps1",
        "tools/export-github-release-state.ps1",
        "tools/test-github-branch-protection.ps1",
        "tools/set-github-branch-protection.ps1",
        "tools/test-nas-access.ps1",
        "tools/export-release-blocker-action-plan.ps1",
        "tools/export-unity-pre-smoke-status.ps1",
        "tools/export-unity-interactive-smoke-plan.ps1",
        "tools/export-unity-asset-replacement-worklist.ps1",
        "tools/export-public-asset-manifest.ps1",
        "tools/export-unity-attribution-gap-report.ps1",
        "tools/export-unity-third-party-removal-status.ps1",
        "tools/export-public-release-file-plan.ps1",
        "tools/export-google-drive-public-manifest.ps1",
        "tools/export-nas-inventory.ps1"
    )
    $missingFiles = @($requiredFiles | Where-Object { -not (Test-Path -LiteralPath $_) })
    Add-Gate $gates "Required handoff docs" ($(if ($missingFiles.Count -eq 0) { "pass" } else { "blocker" })) ($(if ($missingFiles.Count -eq 0) { "All expected handoff docs and inventories are present." } else { "Missing: " + ($missingFiles -join ", ") })) "Restore missing docs."

    $requirementRows = @(Import-Csv -LiteralPath "docs/inventory/release-requirements-status.csv")
    $blockedRequirements = @($requirementRows | Where-Object { $_.status -eq "blocked" })
    $releaseBlockerActionRows = @(Import-Csv -LiteralPath "docs/inventory/release-blocker-action-plan.csv")
    $blockedRequirementNames = if ($blockedRequirements.Count -eq 0) {
        "none"
    }
    else {
        ($blockedRequirements | ForEach-Object { "$($_.requirement) ($($_.issue))" }) -join "; "
    }
    Add-Gate $gates "Release evidence manifest" ($(if ($blockedRequirements.Count -eq 0) { "pass" } else { "blocker" })) "$($requirementRows.Count) release requirements tracked; $($blockedRequirements.Count) requirements are blocked: $blockedRequirementNames; $($releaseBlockerActionRows.Count) blocker action rows generated." "Resolve or document every blocked release requirement before changing visibility."

    $sceneValidator = Test-Path -LiteralPath "tools/run-unity-scene-validation.ps1"
    $unityValidation = Select-String -LiteralPath "docs/unity-validation.md" -Pattern "zero missing script references" -Quiet
    Add-Gate $gates "Unity batchmode scene validation" ($(if ($sceneValidator -and $unityValidation) { "pass" } else { "blocker" })) "Scene validator script present: $sceneValidator; docs record zero missing script references: $unityValidation." "Run tools/run-unity-scene-validation.ps1 and update docs/unity-validation.md."

    $unitySmokeRows = @(Import-Csv -LiteralPath "docs/inventory/unity-smoke-test-status.csv")
    $smokeRequirement = $requirementRows | Where-Object { $_.requirement -eq "Complete interactive Unity/VR smoke testing" } | Select-Object -First 1
    $openUnitySmokeSteps = @($unitySmokeRows | Where-Object { $_.status -ne "complete" })
    $preSmokeRows = @(Import-Csv -LiteralPath "docs/inventory/unity-pre-smoke-status.csv")
    $readyPreSmokeRows = @($preSmokeRows | Where-Object { $_.status -eq "ready_for_interactive_smoke" })
    $interactiveSmokePlanRows = @(Import-Csv -LiteralPath "docs/inventory/unity-interactive-smoke-plan.csv")
    $interactiveSmokeRiskRefs = 0
    foreach ($row in $interactiveSmokePlanRows) {
        $interactiveSmokeRiskRefs += [int]$row.risky_asset_reference_count
    }
    $smokeGateStatus = if ($openUnitySmokeSteps.Count -eq 0) { "pass" } elseif ($smokeRequirement -and $smokeRequirement.status -eq "deferred_optional") { "deferred" } else { "blocker" }
    $smokeNextStep = if ($smokeGateStatus -eq "deferred") { "Optional before a VR gameplay release; not required for the current private source-prep scope." } else { "Open the project interactively, smoke-test README scenes, and update issue #3." }
    Add-Gate $gates "Unity interactive smoke testing" $smokeGateStatus "$($openUnitySmokeSteps.Count) Unity smoke-test status rows are not complete; $($readyPreSmokeRows.Count) of $($preSmokeRows.Count) README scenes pass automated pre-smoke structural checks; $($interactiveSmokePlanRows.Count) scene-level interactive smoke plan rows track $interactiveSmokeRiskRefs risky asset references to inspect visually; current requirement status: $($smokeRequirement.status)." $smokeNextStep

    $assetAuditRows = @(Import-Csv -LiteralPath "docs/inventory/unity-asset-audit.csv")
    $assetReferenceRows = @(Import-Csv -LiteralPath "docs/inventory/unity-risky-asset-references.csv")
    $assetReplacementWorkRows = @(Import-Csv -LiteralPath "docs/inventory/unity-asset-replacement-worklist.csv")
    $publicAssetManifestRows = @(Import-Csv -LiteralPath "docs/inventory/unity-public-asset-manifest.csv")
    $attributionGapRows = @(Import-Csv -LiteralPath "docs/inventory/unity-attribution-gap-report.csv")
    $removalStatusRows = @(Import-Csv -LiteralPath "docs/inventory/unity-third-party-removal-status.csv")
    $publicReleaseFilePlanRows = @(Import-Csv -LiteralPath "docs/inventory/public-release-file-plan.csv")
    $assetDispositionRows = @(Import-Csv -LiteralPath "docs/inventory/unity-asset-disposition.csv")
    $externalImportRows = @(Import-Csv -LiteralPath "docs/inventory/unity-external-imports.csv")
    $assetBlockers = @($publicAssetManifestRows | Where-Object {
        $_.public_repo_treatment -ne "retain_candidate_reviewed"
    })
    $referencedRiskyFolders = @($assetReferenceRows | Where-Object { [int]$_.external_reference_count -gt 0 })
    $pendingDispositions = @($assetDispositionRows | Where-Object { $_.release_decision -eq "pending" })
    $coveredExternalImportRows = @($externalImportRows | Where-Object { ($pendingDispositions.folder) -contains $_.folder })
    $publicAssetExclusions = @($publicAssetManifestRows | Where-Object { $_.public_repo_treatment -match "exclude|replace" })
    $attributionPendingRows = @($attributionGapRows | Where-Object { $_.notice_status -match "defer|pending|owner_review_required" })
    $removedRows = @($removalStatusRows | Where-Object { $_.removal_status -eq "removed_from_repo" })
    $safeDeletionRows = @($removalStatusRows | Where-Object { $_.safe_to_delete_now -eq "yes" })
    $publicFileExclusions = @($publicReleaseFilePlanRows | Where-Object { $_.action -eq "exclude_until_resolved" })
    $unityAssetGatePass = (
        $assetBlockers.Count -eq 0 -and
        $pendingDispositions.Count -eq 0 -and
        $publicAssetExclusions.Count -eq 0 -and
        $publicFileExclusions.Count -eq 0 -and
        $attributionPendingRows.Count -eq 0
    )
    Add-Gate $gates "Unity third-party asset release decisions" ($(if ($unityAssetGatePass) { "pass" } else { "blocker" })) "$($assetAuditRows.Count) asset folders audited; $($assetBlockers.Count) audited folders still need rights/replacement decisions; $($referencedRiskyFolders.Count) risky folders have serialized references to bundled high-risk folders; $($assetReplacementWorkRows.Count) removal/reconstruction worklist rows are tracked; $($pendingDispositions.Count) asset disposition rows are pending; $($removedRows.Count) high-risk folders are removed from the repo; $($coveredExternalImportRows.Count) pending/removed folders have external import/removal handoff rows; $($safeDeletionRows.Count) high-risk folders are currently safe to delete without replacing references; $($publicAssetExclusions.Count) public asset manifest rows and $($publicFileExclusions.Count) tracked files require exclusion/replacement/import before public release; $($attributionPendingRows.Count) attribution/NOTICE rows still require owner, package, or final asset-decision review." "If this gate is not passing, resolve issue #2 by replacing referenced downloaded assets, removing assets after references are cleared, documenting import steps, and updating NOTICE for retained third-party material."

    $nasRows = @(Import-Csv -LiteralPath "docs/inventory/nas-access-log.csv")
    $nasRequirement = $requirementRows | Where-Object { $_.requirement -eq "Review attached NAS Youssef Storage" } | Select-Object -First 1
    $nasStatusRows = @(Import-Csv -LiteralPath "docs/inventory/nas-review-status.csv")
    $nasEvidence = ($nasRows | ForEach-Object { "$($_.check): $($_.result)" }) -join "; "
    $openNasSteps = @($nasStatusRows | Where-Object { $_.status -ne "complete" })
    $nasBlocked = $nasEvidence -match "blocked|password required|no active" -or $openNasSteps.Count -gt 0
    $nasGateStatus = if (-not $nasBlocked) { "pass" } elseif ($nasRequirement -and $nasRequirement.status -eq "excluded_by_user") { "deferred" } else { "blocker" }
    $nasNextStep = if ($nasGateStatus -eq "deferred") { "No action for the current scope; user removed NAS files from the release-prep requirement." } else { "Mount/authenticate to Youssef Storage / WDMyCloudEX4100 and inventory 21Verse files." }
    Add-Gate $gates "NAS review" $nasGateStatus "NAS access log records: $nasEvidence; $($openNasSteps.Count) NAS review status rows are not complete; current requirement status: $($nasRequirement.status)." $nasNextStep

    $driveRows = @(Import-Csv -LiteralPath "docs/inventory/google-drive-21verse.csv")
    $driveManifestRows = @(Import-Csv -LiteralPath "docs/inventory/google-drive-public-manifest.csv")
    $privateDriveRows = @($driveManifestRows | Where-Object { $_.export_gate -eq "keep_private_no_public_export" })
    $reviewDriveRows = @($driveManifestRows | Where-Object { $_.export_gate -match "sanitize|redact|manual" })
    $stagedDriveRows = @($driveManifestRows | Where-Object { $_.export_gate -match "already_staged" })
    Add-Gate $gates "Google Drive inventory" ($(if ($driveRows.Count -gt 0 -and $driveManifestRows.Count -eq $driveRows.Count) { "pass" } else { "blocker" })) "$($driveRows.Count) Google Drive rows inventoried; $($driveManifestRows.Count) Drive public manifest rows tracked; $($privateDriveRows.Count) rows gated private; $($reviewDriveRows.Count) rows require sanitization/redaction/manual review; $($stagedDriveRows.Count) rows have staged local derivatives." "Only export public-safe, redacted docs/decks when selected."

    $branchProtectionRows = @(Import-Csv -LiteralPath "docs/inventory/github-branch-protection-status.csv")
    $branchProtectionRequirement = $requirementRows | Where-Object { $_.requirement -eq "Verify GitHub branch protection before public release" } | Select-Object -First 1
    $openBranchProtectionRows = @($branchProtectionRows | Where-Object { $_.status -ne "complete" })
    $githubReleaseStateRows = @(Import-Csv -LiteralPath "docs/inventory/github-release-state.csv")
    $githubVisibilityRow = $githubReleaseStateRows | Where-Object { $_.setting -eq "visibility" } | Select-Object -First 1
    $branchProtectionEvidence = if ($openBranchProtectionRows.Count -eq 0) {
        "$($branchProtectionRows.Count) branch protection rows verified complete."
    }
    else {
        ($openBranchProtectionRows | ForEach-Object { "$($_.setting): $($_.status)" }) -join "; "
    }
    $branchProtectionGateStatus = if ($openBranchProtectionRows.Count -eq 0) {
        "pass"
    }
    elseif ($branchProtectionRequirement -and $branchProtectionRequirement.status -eq "deferred_platform_limit") {
        "deferred"
    }
    else {
        "blocker"
    }
    $branchProtectionNextStep = if ($branchProtectionGateStatus -eq "deferred") {
        "Enable branch protection immediately after the repo is made public, or upgrade GitHub Pro while keeping it private."
    }
    else {
        "Verify branch protection from a GitHub admin session before public release."
    }
    Add-Gate $gates "GitHub branch protection" $branchProtectionGateStatus "$branchProtectionEvidence; github_visibility_snapshot: $($githubVisibilityRow.status); current requirement status: $($branchProtectionRequirement.status)" $branchProtectionNextStep

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
