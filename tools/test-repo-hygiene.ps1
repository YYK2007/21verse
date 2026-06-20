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
        "docs/asset-disposition-tracker.md",
        "docs/unity-external-imports.md",
        "docs/public-asset-manifest.md",
        "docs/unity-attribution-gap-report.md",
        "docs/github-metadata.md",
        "docs/github-tracker.md",
        "docs/inventory/release-audit.md",
        "docs/inventory/github-release-state.csv",
        "docs/inventory/release-blocker-action-plan.csv",
        "docs/inventory/github-branch-protection-status.csv",
        "docs/inventory/release-requirements-status.csv",
        "docs/inventory/local-drive-review-status.csv",
        "docs/inventory/google-drive-21verse.csv",
        "docs/inventory/google-drive-release-plan.csv",
        "docs/inventory/google-drive-public-manifest.csv",
        "docs/inventory/public-release-file-plan.csv",
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
        "tools/test-github-release-state.ps1",
        "tools/export-github-release-state.ps1",
        "tools/test-github-branch-protection.ps1",
        "tools/set-github-branch-protection.ps1",
        "tools/test-nas-access.ps1",
        "tools/export-local-drive-review-status.ps1",
        "tools/export-unity-pre-smoke-status.ps1",
        "tools/export-release-blocker-action-plan.ps1",
        "tools/export-unity-interactive-smoke-plan.ps1",
        "tools/run-release-audit.ps1",
        "tools/export-nas-inventory.ps1",
        "tools/export-google-drive-public-manifest.ps1",
        "tools/export-unity-asset-replacement-worklist.ps1",
        "tools/export-public-asset-manifest.ps1",
        "tools/export-unity-attribution-gap-report.ps1",
        "tools/export-public-release-file-plan.ps1",
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
        "docs/inventory/google-drive-public-manifest.csv" = 1
        "docs/inventory/public-release-file-plan.csv" = 1
        "docs/inventory/github-branch-protection-status.csv" = 5
        "docs/inventory/github-release-state.csv" = 12
        "docs/inventory/release-blocker-action-plan.csv" = 4
        "docs/inventory/release-requirements-status.csv" = 10
        "docs/inventory/local-drive-review-status.csv" = 2
        "docs/inventory/nas-review-status.csv" = 5
        "docs/inventory/unity-smoke-test-status.csv" = 5
        "docs/inventory/unity-pre-smoke-status.csv" = 7
        "docs/inventory/unity-interactive-smoke-plan.csv" = 7
        "docs/inventory/unity-asset-audit.csv" = 18
        "docs/inventory/unity-asset-disposition.csv" = 9
        "docs/inventory/unity-external-imports.csv" = 9
        "docs/inventory/unity-public-asset-manifest.csv" = 18
        "docs/inventory/unity-attribution-gap-report.csv" = 18
        "docs/inventory/unity-risky-asset-references.csv" = 9
        "docs/inventory/unity-asset-replacement-worklist.csv" = 47
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

    $driveReleaseRows = @(Import-Csv -LiteralPath "docs/inventory/google-drive-release-plan.csv")
    $driveManifestRows = @(Import-Csv -LiteralPath "docs/inventory/google-drive-public-manifest.csv")
    if ($driveManifestRows.Count -ne $driveReleaseRows.Count) {
        Add-Failure "Google Drive public manifest has $($driveManifestRows.Count) rows; expected $($driveReleaseRows.Count) from google-drive-release-plan.csv."
    }

    $localDriveRows = @(Import-Csv -LiteralPath "docs/inventory/local-drive-review-status.csv")
    foreach ($expectedRoot in @("D:\Unity", "E:\Users\Yasser\Documents")) {
        if (@($localDriveRows | Where-Object { $_.root -eq $expectedRoot }).Count -eq 0) {
            Add-Failure "Local drive review status is missing root '$expectedRoot'."
        }
    }

    foreach ($row in $localDriveRows) {
        if ([string]::IsNullOrWhiteSpace($row.root) -or
            [string]::IsNullOrWhiteSpace($row.status) -or
            [string]::IsNullOrWhiteSpace($row.notes)) {
            Add-Failure "Local drive review status row '$($row.root)' is missing required detail."
        }

        if (@("reviewed", "blocked", "missing") -notcontains $row.status) {
            Add-Failure "Local drive review status row '$($row.root)' has unexpected status '$($row.status)'."
        }
    }

    foreach ($row in $driveManifestRows) {
        if ([string]::IsNullOrWhiteSpace($row.title) -or
            [string]::IsNullOrWhiteSpace($row.public_release_decision) -or
            [string]::IsNullOrWhiteSpace($row.export_gate) -or
            [string]::IsNullOrWhiteSpace($row.required_review)) {
            Add-Failure "Google Drive public manifest row '$($row.title)' is missing release handoff detail."
        }

        if ($row.public_release_decision -eq "exclude_private" -and $row.export_gate -ne "keep_private_no_public_export") {
            Add-Failure "Google Drive private row '$($row.title)' has export gate '$($row.export_gate)'."
        }

        if (-not [string]::IsNullOrWhiteSpace($row.local_public_artifact) -and -not (Test-Path -LiteralPath $row.local_public_artifact)) {
            Add-Failure "Google Drive public manifest row '$($row.title)' references missing local artifact '$($row.local_public_artifact)'."
        }
    }

    $referenceRowsForWorklistCheck = @(Import-Csv -LiteralPath "docs/inventory/unity-risky-asset-references.csv")
    $worklistRows = @(Import-Csv -LiteralPath "docs/inventory/unity-asset-replacement-worklist.csv")
    $expectedWorklistCount = 0
    foreach ($row in $referenceRowsForWorklistCheck) {
        $expectedWorklistCount += @($row.referenced_by -split ';' | Where-Object { -not [string]::IsNullOrWhiteSpace($_.Trim()) }).Count
    }

    if ($worklistRows.Count -ne $expectedWorklistCount) {
        Add-Failure "Unity asset replacement worklist has $($worklistRows.Count) rows; expected $expectedWorklistCount from unity-risky-asset-references.csv."
    }

    foreach ($row in $worklistRows) {
        if ([string]::IsNullOrWhiteSpace($row.folder) -or
            [string]::IsNullOrWhiteSpace($row.referenced_file) -or
            [string]::IsNullOrWhiteSpace($row.recommended_action) -or
            $row.issue -ne "#2") {
            Add-Failure "Unity asset replacement worklist row for '$($row.folder)' / '$($row.referenced_file)' is missing required release handoff detail."
        }
    }

    $preSmokeRows = @(Import-Csv -LiteralPath "docs/inventory/unity-pre-smoke-status.csv")
    foreach ($row in $preSmokeRows) {
        if ($row.status -ne "ready_for_interactive_smoke") {
            Add-Failure "Unity pre-smoke row '$($row.scene)' is not ready: $($row.notes)"
        }
    }

    $interactiveSmokePlanRows = @(Import-Csv -LiteralPath "docs/inventory/unity-interactive-smoke-plan.csv")
    foreach ($row in $interactiveSmokePlanRows) {
        if ($row.status -ne "pending_interactive_smoke" -or
            $row.issue -ne "#3" -or
            [string]::IsNullOrWhiteSpace($row.required_manual_checks) -or
            [string]::IsNullOrWhiteSpace($row.pass_condition)) {
            Add-Failure "Unity interactive smoke plan row '$($row.scene)' is missing required manual validation detail."
        }
    }

    $branchProtectionRows = @(Import-Csv -LiteralPath "docs/inventory/github-branch-protection-status.csv")
    $allowedBranchProtectionStatuses = @(
        "complete",
        "blocked",
        "missing",
        "pending_admin_verification"
    )
    foreach ($row in $branchProtectionRows) {
        if ([string]::IsNullOrWhiteSpace($row.setting) -or
            $allowedBranchProtectionStatuses -notcontains $row.status -or
            [string]::IsNullOrWhiteSpace($row.evidence) -or
            [string]::IsNullOrWhiteSpace($row.next_action)) {
            Add-Failure "GitHub branch protection status row '$($row.setting)' is missing required handoff detail or has unexpected status '$($row.status)'."
        }
    }

    $assetDispositionRowsForImportCheck = @(Import-Csv -LiteralPath "docs/inventory/unity-asset-disposition.csv")
    $externalImportRows = @(Import-Csv -LiteralPath "docs/inventory/unity-external-imports.csv")
    $externalImportFolders = @($externalImportRows | ForEach-Object { $_.folder })
    $pendingDispositionFolders = @($assetDispositionRowsForImportCheck |
        Where-Object { $_.release_decision -eq "pending" } |
        ForEach-Object { $_.folder })

    foreach ($folder in $pendingDispositionFolders) {
        if ($externalImportFolders -notcontains $folder) {
            Add-Failure "Pending Unity asset disposition folder '$folder' is missing from docs/inventory/unity-external-imports.csv."
        }
    }

    foreach ($row in $externalImportRows) {
        if ($pendingDispositionFolders -notcontains $row.folder) {
            Add-Failure "Unity external import row '$($row.folder)' does not correspond to a pending asset disposition row."
        }

        if ([string]::IsNullOrWhiteSpace($row.source_type) -or
            [string]::IsNullOrWhiteSpace($row.source_evidence) -or
            [string]::IsNullOrWhiteSpace($row.preferred_public_release_treatment) -or
            [string]::IsNullOrWhiteSpace($row.import_or_replacement_path)) {
            Add-Failure "Unity external import row '$($row.folder)' is missing required handoff detail."
        }

        if ($row.issue -ne "#2") {
            Add-Failure "Unity external import row '$($row.folder)' is linked to '$($row.issue)', expected '#2'."
        }
    }

    $publicAssetManifestRows = @(Import-Csv -LiteralPath "docs/inventory/unity-public-asset-manifest.csv")
    $auditFolders = @(Import-Csv -LiteralPath "docs/inventory/unity-asset-audit.csv" | ForEach-Object { $_.folder })
    $manifestFolders = @($publicAssetManifestRows | ForEach-Object { $_.folder })
    foreach ($folder in $auditFolders) {
        if ($manifestFolders -notcontains $folder) {
            Add-Failure "Unity public asset manifest is missing audited folder '$folder'."
        }
    }

    foreach ($row in $publicAssetManifestRows) {
        if ([string]::IsNullOrWhiteSpace($row.public_repo_treatment) -or
            [string]::IsNullOrWhiteSpace($row.public_release_resolution) -or
            [string]::IsNullOrWhiteSpace($row.validation_required)) {
            Add-Failure "Unity public asset manifest row '$($row.folder)' is missing release handoff detail."
        }
    }

    $attributionGapRows = @(Import-Csv -LiteralPath "docs/inventory/unity-attribution-gap-report.csv")
    $attributionFolders = @($attributionGapRows | ForEach-Object { $_.folder })
    foreach ($folder in $auditFolders) {
        if ($attributionFolders -notcontains $folder) {
            Add-Failure "Unity attribution gap report is missing audited folder '$folder'."
        }
    }

    foreach ($row in $attributionGapRows) {
        if ([string]::IsNullOrWhiteSpace($row.public_repo_treatment) -or
            [string]::IsNullOrWhiteSpace($row.notice_status) -or
            [string]::IsNullOrWhiteSpace($row.notice_required_before_public) -or
            [string]::IsNullOrWhiteSpace($row.recommended_notice_action)) {
            Add-Failure "Unity attribution gap row '$($row.folder)' is missing required NOTICE handoff detail."
        }

        if (($row.public_repo_treatment -match "exclude|replace" -or $row.release_decision -eq "pending") -and $row.issue -ne "#2") {
            Add-Failure "Unity attribution gap row '$($row.folder)' is linked to '$($row.issue)', expected '#2'."
        }
    }

    $releaseFilePlanRows = @(Import-Csv -LiteralPath "docs/inventory/public-release-file-plan.csv")
    $trackedFilesForPlan = @(git ls-files)
    $plannedPaths = @($releaseFilePlanRows | ForEach-Object { $_.path })
    foreach ($path in $trackedFilesForPlan) {
        if ($plannedPaths -notcontains $path) {
            Add-Failure "Public release file plan is missing tracked path '$path'."
        }
    }

    foreach ($row in $releaseFilePlanRows) {
        if ([string]::IsNullOrWhiteSpace($row.path) -or
            [string]::IsNullOrWhiteSpace($row.action) -or
            [string]::IsNullOrWhiteSpace($row.reason)) {
            Add-Failure "Public release file plan row '$($row.path)' is missing path, action, or reason."
        }
    }

    $githubReleaseRows = @(Import-Csv -LiteralPath "docs/inventory/github-release-state.csv")
    foreach ($expectedSetting in @("visibility", "default_branch", "public_release_readiness", "#1", "#2", "#3", "#5", "repo_hygiene_latest_completed")) {
        if (@($githubReleaseRows | Where-Object { $_.setting -eq $expectedSetting }).Count -eq 0) {
            Add-Failure "GitHub release state snapshot is missing setting '$expectedSetting'."
        }
    }

    $visibilityRow = $githubReleaseRows | Where-Object { $_.setting -eq "visibility" } | Select-Object -First 1
    if ($visibilityRow.status -ne "private") {
        Add-Failure "GitHub release state snapshot visibility is '$($visibilityRow.status)', expected private."
    }

    $requirementRows = @(Import-Csv -LiteralPath "docs/inventory/release-requirements-status.csv")
    $releaseBlockerActionRows = @(Import-Csv -LiteralPath "docs/inventory/release-blocker-action-plan.csv")
    $blockedRequirementRowsForPlan = @($requirementRows | Where-Object { $_.status -eq "blocked" })
    if ($releaseBlockerActionRows.Count -ne $blockedRequirementRowsForPlan.Count) {
        Add-Failure "Release blocker action plan has $($releaseBlockerActionRows.Count) rows; expected $($blockedRequirementRowsForPlan.Count) blocked requirements."
    }

    foreach ($row in $releaseBlockerActionRows) {
        if ([string]::IsNullOrWhiteSpace($row.requirement) -or
            [string]::IsNullOrWhiteSpace($row.issue) -or
            [string]::IsNullOrWhiteSpace($row.owner_action) -or
            [string]::IsNullOrWhiteSpace($row.completion_evidence) -or
            [string]::IsNullOrWhiteSpace($row.external_dependency)) {
            Add-Failure "Release blocker action plan row '$($row.requirement)' is missing required handoff detail."
        }
    }

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

        $evidencePaths = @($row.evidence -split ';' |
            ForEach-Object { $_.Trim() } |
            Where-Object { -not [string]::IsNullOrWhiteSpace($_) })

        foreach ($path in $evidencePaths) {
            if (-not (Test-Path -LiteralPath $path)) {
                Add-Failure "Release requirement '$($row.requirement)' references missing evidence path '$path'."
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

    $unityValidation = Get-Content -LiteralPath "docs/unity-validation.md" -Raw
    if ($unityValidation -notmatch "Status as of 2026-06-20" -or
        $unityValidation -notmatch "Cashier.*build-settings update" -or
        $unityValidation -notmatch "Root objects" -or
        $unityValidation -notmatch "GameObjects") {
        Add-Failure "Unity validation summary is missing the latest 2026-06-20 scene-validation evidence."
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
