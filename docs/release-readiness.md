# Release Readiness Checklist

This repository is private and staged for a future open-source release. Do not make it public until the checks below are complete.

## Current Status

- Private GitHub repository exists: `YYK2007/21verse_opensource`.
- Curated Unity project is included under `unity/21verse-vr-game-hub`.
- Local Unity projects and local design files have machine-readable inventories in `docs/inventory/`.
- Google Drive presentations, docs, and sheets have a curated inventory in `docs/inventory/google-drive-21verse.csv`.
- Google Drive public-release decisions are staged in `docs/inventory/google-drive-release-plan.csv` and summarized in `docs/google-drive-release-plan.md`.
- Google Drive public/private export gates are tracked in `docs/google-drive-public-manifest.md` and `docs/inventory/google-drive-public-manifest.csv`.
- Unity `2022.3.25f1` batchmode project open/import passed for `unity/21verse-vr-game-hub`, and all listed scenes open in batchmode with zero missing script references; see `docs/unity-validation.md`.
- Interactive Unity/VR smoke-test status is tracked in `docs/unity-smoke-test-checklist.md` and `docs/inventory/unity-smoke-test-status.csv`.
- Unity pre-smoke structural status is tracked in `docs/inventory/unity-pre-smoke-status.csv`.
- Scene-level interactive Unity smoke-test planning is tracked in `docs/unity-interactive-smoke-plan.md` and `docs/inventory/unity-interactive-smoke-plan.csv`.
- Unity bundled asset folders have a machine-readable audit in `docs/inventory/unity-asset-audit.csv`.
- Risky Unity asset references are mapped in `docs/inventory/unity-risky-asset-references.csv` and summarized in `docs/asset-removal-plan.md`.
- Scene/prefab/material replacement work for risky Unity assets is tracked in `docs/inventory/unity-asset-replacement-worklist.csv`.
- Unity asset release decisions are tracked in `docs/asset-disposition-tracker.md` and `docs/inventory/unity-asset-disposition.csv`.
- Unity external import/removal paths are tracked in `docs/unity-external-imports.md` and `docs/inventory/unity-external-imports.csv`.
- Unity public asset keep/exclude/replacement treatment is tracked in `docs/public-asset-manifest.md` and `docs/inventory/unity-public-asset-manifest.csv`.
- The tracked-file public release dry run is tracked in `docs/public-release-file-plan.md` and `docs/inventory/public-release-file-plan.csv`.
- Current local release gate snapshot is in `docs/inventory/release-audit.md`.
- Release evidence is mapped in `docs/release-evidence-manifest.md` and `docs/inventory/release-requirements-status.csv`.
- Final publication steps are documented in `docs/public-release-runbook.md`.
- Public-repo governance docs and GitHub issue/PR templates are staged for release review.
- Conduct, support, and changelog docs are staged for public release review.
- Lightweight repository hygiene checks and a GitHub Actions private-visibility guard are staged in `.github/workflows/repo-hygiene.yml`.
- Repository ownership and dependency-maintenance config are staged in `.github/CODEOWNERS`, `.github/dependabot.yml`, and `docs/repository-maintenance.md`.
- GitHub tracker milestone and labels are documented in `docs/github-tracker.md`.
- GitHub repository metadata is documented in `docs/github-metadata.md`.
- GitHub branch protection handoff is documented in `docs/github-branch-protection.md`.
- GitHub branch protection admin-verification status is tracked in `docs/inventory/github-branch-protection-status.csv`.
- NAS device has been identified but not reviewed because share access is blocked.
- NAS review instructions are staged in `docs/nas-review-runbook.md`.
- NAS review completion status is tracked in `docs/nas-review-checklist.md` and `docs/inventory/nas-review-status.csv`.

## Required Before Public Release

1. NAS review
   - Mount or authenticate to `Youssef Storage` / `WDMyCloudEX4100`.
   - Run `tools/export-nas-inventory.ps1` against the mounted share.
   - Search for 21Verse files on the NAS.
   - Add any repo-worthy files or document exclusions.
   - Mark every row in `docs/inventory/nas-review-status.csv` as `complete`.
   - Close GitHub issue #1.

2. Unity asset licensing
   - Regenerate `docs/inventory/unity-asset-audit.csv` with `tools/export-unity-asset-audit.ps1` after asset changes.
   - Regenerate `docs/inventory/unity-risky-asset-references.csv` with `tools/export-unity-risky-asset-references.ps1` after asset changes.
   - Regenerate `docs/inventory/unity-asset-replacement-worklist.csv` with `tools/export-unity-asset-replacement-worklist.ps1`.
   - Review the UPM/package and bundled asset handoff in `docs/unity-dependencies.md`.
   - Review the external import/removal handoff in `docs/unity-external-imports.md`.
   - Follow `docs/asset-removal-plan.md` for replacement/removal sequencing.
   - Use `docs/public-asset-manifest.md` and `docs/inventory/unity-public-asset-manifest.csv` as the keep/exclude/replacement map for the eventual public branch cut.
   - Regenerate `docs/inventory/public-release-file-plan.csv` with `tools/export-public-release-file-plan.ps1` to review tracked include/exclude effects before any public branch cut.
   - Resolve all `pending` rows in `docs/inventory/unity-asset-disposition.csv`.
   - Resolve all high-priority items in `docs/third-party-assets.md`.
   - Remove or replace any asset that cannot be redistributed in a public source repo.
   - Update `NOTICE.md`.
   - Close GitHub issue #2.

3. Unity validation
   - Batchmode open/import with Unity `2022.3.25f1` passed on 2026-06-19.
   - Batchmode scene-open validation passed for all main scenes with zero missing script references.
   - Regenerate `docs/inventory/unity-pre-smoke-status.csv` with `tools/export-unity-pre-smoke-status.ps1`.
   - Regenerate `docs/inventory/unity-interactive-smoke-plan.csv` with `tools/export-unity-interactive-smoke-plan.ps1`.
   - Load and smoke-test the main scenes listed in `README.md`.
   - Review shader fallback warnings seen during import.
   - Mark every row in `docs/inventory/unity-smoke-test-status.csv` as `complete`.
   - Close GitHub issue #3.

4. Google Drive/public docs
   - Review `docs/inventory/google-drive-21verse.csv`.
   - Regenerate `docs/inventory/google-drive-release-plan.csv` with `tools/export-google-drive-release-plan.ps1` after Drive inventory changes.
   - Regenerate `docs/inventory/google-drive-public-manifest.csv` with `tools/export-google-drive-public-manifest.ps1`.
   - Follow `docs/google-drive-release-plan.md` before exporting any Google Drive material into `docs/`.
   - Export only redacted, public-safe versions of selected decks/docs.
   - Keep testing, IRB, financial, investor, outreach, and partner materials private unless deliberately sanitized.

5. Final repo hygiene
   - Follow `docs/public-release-runbook.md`.
   - Review `docs/release-evidence-manifest.md`.
   - Confirm `docs/inventory/release-requirements-status.csv` has no `blocked` rows.
   - Run `tools/test-repo-hygiene.ps1`.
   - Run `tools/run-release-audit.ps1`.
   - Run `tools/test-github-release-state.ps1`.
   - Review `CONTRIBUTING.md`, `SECURITY.md`, and `.github/` templates.
   - Review `CODE_OF_CONDUCT.md`, `SUPPORT.md`, and `CHANGELOG.md`.
   - Review `.github/CODEOWNERS`, `.github/dependabot.yml`, and `docs/repository-maintenance.md`.
   - Review `docs/github-metadata.md`.
   - Review `docs/github-branch-protection.md`.
   - Resolve GitHub issue #5 and confirm branch protection status rows are `complete`.
   - Confirm the `Public release readiness` milestone has no open blocker issues.
   - Run a secret scan.
   - Confirm no non-LFS file exceeds GitHub's 100 MB limit.
   - Confirm `git status --short --branch` is clean.
   - Confirm GitHub visibility remains private until the final release decision.

## Useful Commands

```powershell
git status --short --branch
git lfs ls-files | Measure-Object
Get-ChildItem -Recurse -Force -File | Where-Object { $_.FullName -notmatch '\\.git\\' -and $_.Length -gt 100MB }
rg -n --hidden -S "(api[_-]?key|secret|password|passwd|token|client_secret|private_key|BEGIN RSA|BEGIN PRIVATE|ghp_|AIza|sk-[A-Za-z0-9])" --glob "!.git/**" .
```
