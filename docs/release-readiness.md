# Release Readiness Checklist

This repository is private and staged for a future open-source release. Do not make it public until the checks below are complete.

## Current Status

- Private GitHub repository exists: `YYK2007/21verse_opensource`.
- Curated Unity project is included under `unity/21verse-vr-game-hub`.
- Local Unity projects and local design files have machine-readable inventories in `docs/inventory/`.
- Google Drive presentations, docs, and sheets have a curated inventory in `docs/inventory/google-drive-21verse.csv`.
- Unity `2022.3.25f1` batchmode project open/import passed for `unity/21verse-vr-game-hub`, and all listed scenes open in batchmode with zero missing script references; see `docs/unity-validation.md`.
- Unity bundled asset folders have a machine-readable audit in `docs/inventory/unity-asset-audit.csv`.
- Risky Unity asset references are mapped in `docs/inventory/unity-risky-asset-references.csv` and summarized in `docs/asset-removal-plan.md`.
- Current local release gate snapshot is in `docs/inventory/release-audit.md`.
- Public-repo governance docs and GitHub issue/PR templates are staged for release review.
- Lightweight repository hygiene checks are staged in `.github/workflows/repo-hygiene.yml`.
- Repository ownership and dependency-maintenance config are staged in `.github/CODEOWNERS`, `.github/dependabot.yml`, and `docs/repository-maintenance.md`.
- NAS device has been identified but not reviewed because share access is blocked.

## Required Before Public Release

1. NAS review
   - Mount or authenticate to `Youssef Storage` / `WDMyCloudEX4100`.
   - Search for 21Verse files on the NAS.
   - Add any repo-worthy files or document exclusions.
   - Close GitHub issue #1.

2. Unity asset licensing
   - Regenerate `docs/inventory/unity-asset-audit.csv` with `tools/export-unity-asset-audit.ps1` after asset changes.
   - Regenerate `docs/inventory/unity-risky-asset-references.csv` with `tools/export-unity-risky-asset-references.ps1` after asset changes.
   - Review the UPM/package and bundled asset handoff in `docs/unity-dependencies.md`.
   - Follow `docs/asset-removal-plan.md` for replacement/removal sequencing.
   - Resolve all high-priority items in `docs/third-party-assets.md`.
   - Remove or replace any asset that cannot be redistributed in a public source repo.
   - Update `NOTICE.md`.
   - Close GitHub issue #2.

3. Unity validation
   - Batchmode open/import with Unity `2022.3.25f1` passed on 2026-06-19.
   - Batchmode scene-open validation passed for all main scenes with zero missing script references.
   - Load and smoke-test the main scenes listed in `README.md`.
   - Review shader fallback warnings seen during import.
   - Close GitHub issue #3.

4. Google Drive/public docs
   - Review `docs/inventory/google-drive-21verse.csv`.
   - Export only redacted, public-safe versions of selected decks/docs.
   - Keep testing, IRB, financial, investor, outreach, and partner materials private unless deliberately sanitized.

5. Final repo hygiene
   - Run `tools/test-repo-hygiene.ps1`.
   - Run `tools/run-release-audit.ps1`.
   - Review `CONTRIBUTING.md`, `SECURITY.md`, and `.github/` templates.
   - Review `.github/CODEOWNERS`, `.github/dependabot.yml`, and `docs/repository-maintenance.md`.
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
