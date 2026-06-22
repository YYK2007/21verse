# Release Readiness Checklist

This repository is approved for public open-source release. Keep the checks below current for future release work.

## Current Status

- Public GitHub repository exists: `YYK2007/21verse`.
- Curated Unity project is included under `unity/21verse-vr-game-hub`.
- Local Unity projects and local design files have machine-readable inventories in `docs/inventory/`.
- Google Drive presentations, docs, and sheets have a curated inventory in `docs/inventory/google-drive-21verse.csv`.
- Google Drive public-release decisions are staged in `docs/inventory/google-drive-release-plan.csv` and summarized in `docs/google-drive-release-plan.md`.
- Google Drive public/private export gates are tracked in `docs/google-drive-public-manifest.md` and `docs/inventory/google-drive-public-manifest.csv`.
- Unity `2022.3.25f1` batchmode project open/import passed for `unity/21verse-vr-game-hub`, and all listed scenes open in batchmode with zero missing script references; see `docs/unity-validation.md`.
- Interactive Unity/VR smoke-test status is tracked in `docs/unity-smoke-test-checklist.md` and `docs/inventory/unity-smoke-test-status.csv`.
- Unity pre-smoke structural status is tracked in `docs/inventory/unity-pre-smoke-status.csv`.
- Scene-level interactive Unity smoke-test planning is tracked in `docs/unity-interactive-smoke-plan.md` and `docs/inventory/unity-interactive-smoke-plan.csv`.
- Unity retained asset folders and removed high-risk folders have machine-readable audits in `docs/inventory/`.
- Risky Unity asset references are mapped in `docs/inventory/unity-risky-asset-references.csv` and summarized in `docs/asset-removal-plan.md`.
- Scene/prefab/material replacement work for risky Unity assets is tracked in `docs/inventory/unity-asset-replacement-worklist.csv`.
- Unity asset release decisions are tracked in `docs/asset-disposition-tracker.md` and `docs/inventory/unity-asset-disposition.csv`.
- Unity external import/removal paths are tracked in `docs/unity-external-imports.md` and `docs/inventory/unity-external-imports.csv`.
- Unity public asset keep/exclude/replacement treatment is tracked in `docs/public-asset-manifest.md` and `docs/inventory/unity-public-asset-manifest.csv`.
- The tracked-file public release dry run is tracked in `docs/public-release-file-plan.md` and `docs/inventory/public-release-file-plan.csv`.
- Current local release gate snapshot is in `docs/inventory/release-audit.md`.
- Release evidence is mapped in `docs/release-evidence-manifest.md` and `docs/inventory/release-requirements-status.csv`.
- Current blocker owner actions are generated in `docs/release-blocker-action-plan.md` and `docs/inventory/release-blocker-action-plan.csv`.
- Final publication steps are documented in `docs/public-release-runbook.md`.
- Public-repo governance docs and GitHub issue/PR templates are ready for ongoing public maintenance.
- Conduct, support, and changelog docs are public-ready and should stay aligned with the open-source scope.
- Lightweight repository hygiene checks and a GitHub Actions release-blocker guard are available in `.github/workflows/repo-hygiene.yml`.
- Repository ownership and dependency-maintenance config are available in `.github/CODEOWNERS`, `.github/dependabot.yml`, and `docs/repository-maintenance.md`.
- GitHub tracker milestone and labels are documented in `docs/github-tracker.md`.
- GitHub repository metadata is documented in `docs/github-metadata.md`.
- GitHub release-state snapshot is tracked in `docs/github-release-state.md` and `docs/inventory/github-release-state.csv`.
- GitHub branch protection verification is documented in `docs/github-branch-protection.md`.
- GitHub branch protection verification status is tracked in `docs/inventory/github-branch-protection-status.csv`.
- Private archive/NAS files are excluded from the current release-prep scope by maintainer decision.
- NAS review instructions are staged in `docs/nas-review-runbook.md`.
- NAS review completion status is tracked in `docs/nas-review-checklist.md` and `docs/inventory/nas-review-status.csv`.

## Ongoing Release Controls

1. NAS review
   - Excluded from the current release-prep scope by maintainer decision on 2026-06-20.
   - Do not include NAS files unless maintainers reopen this scope.

2. Unity asset licensing
   - Regenerate `docs/inventory/unity-asset-audit.csv` with `tools/export-unity-asset-audit.ps1` after asset changes.
   - Regenerate `docs/inventory/unity-risky-asset-references.csv` with `tools/export-unity-risky-asset-references.ps1` after asset changes.
   - Regenerate `docs/inventory/unity-asset-replacement-worklist.csv` with `tools/export-unity-asset-replacement-worklist.ps1`.
   - Review the UPM/package and removed-asset handoff in `docs/unity-dependencies.md`.
   - Review the external import/removal handoff in `docs/unity-external-imports.md`.
   - Use `docs/public-asset-manifest.md` and `docs/inventory/unity-public-asset-manifest.csv` as the retained-folder map for public release changes.
   - Regenerate `docs/inventory/public-release-file-plan.csv` with `tools/export-public-release-file-plan.ps1` to review tracked include/exclude effects before future release-scope changes.
   - Confirm all rows in `docs/inventory/unity-asset-disposition.csv` are non-`pending`.
   - Keep removed downloaded/third-party asset folders out of Git unless redistribution rights are later confirmed.
   - Update `NOTICE.md` after any future third-party asset change.
   - Keep GitHub issue #2 closed with the removal evidence.

3. Unity validation
   - Batchmode open/import with Unity `2022.3.25f1` passed on 2026-06-19.
   - Batchmode scene-open validation passed for all main scenes with zero missing script references.
   - Regenerate `docs/inventory/unity-pre-smoke-status.csv` with `tools/export-unity-pre-smoke-status.ps1`.
   - Regenerate `docs/inventory/unity-interactive-smoke-plan.csv` with `tools/export-unity-interactive-smoke-plan.ps1`.
   - Interactive Unity/VR smoke testing is deferred by the current maintainer scope and is optional before a VR gameplay release.
   - If that scope is reopened, load and smoke-test the main scenes listed in `README.md`, review shader/material warnings, and update issue #3 evidence.

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
   - Review `docs/release-blocker-action-plan.md`.
   - Confirm `docs/inventory/release-requirements-status.csv` has no `blocked` rows.
   - Run `tools/test-repo-hygiene.ps1`.
   - Run `tools/run-release-audit.ps1`.
   - Run `tools/test-github-release-state.ps1`.
   - Regenerate `docs/inventory/github-release-state.csv` with `tools/export-github-release-state.ps1`.
   - Review `CONTRIBUTING.md`, `SECURITY.md`, and `.github/` templates.
   - Review `CODE_OF_CONDUCT.md`, `SUPPORT.md`, and `CHANGELOG.md`.
   - Review `.github/CODEOWNERS`, `.github/dependabot.yml`, and `docs/repository-maintenance.md`.
   - Review `docs/github-metadata.md`.
   - Review `docs/github-branch-protection.md`.
   - Keep GitHub issue #5 closed with branch-protection verification evidence.
   - Confirm the `Public release readiness` milestone has no open blocker issues.
   - Run a secret scan.
   - Confirm no non-LFS file exceeds GitHub's 100 MB limit.
   - Keep branch protection enabled and verified.
   - Confirm `git status --short --branch` is clean.
   - Confirm GitHub visibility matches the approved release state.

## Useful Commands

```powershell
git status --short --branch
git lfs ls-files | Measure-Object
Get-ChildItem -Recurse -Force -File | Where-Object { $_.FullName -notmatch '\\.git\\' -and $_.Length -gt 100MB }
rg -n --hidden -S "(api[_-]?key|secret|password|passwd|token|client_secret|private_key|BEGIN RSA|BEGIN PRIVATE|ghp_|AIza|sk-[A-Za-z0-9])" --glob "!.git/**" .
```
