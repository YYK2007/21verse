# Public Release Runbook

This runbook describes the publication controls for the public open-source repository. Do not publish future release changes while `docs/inventory/release-audit.md` reports content blockers.

Use `docs/release-evidence-manifest.md` and `docs/inventory/release-requirements-status.csv` as the evidence map for the final review.

## 1. NAS Review Scope

NAS files are excluded from the current release-prep scope by user request on 2026-06-20. Do not include NAS files unless the user reopens this scope.

If NAS review is reopened later:

1. Mount or authenticate to `Youssef Storage` / `WDMyCloudEX4100`.
2. Search for 21Verse files across Unity projects, design files, documents, decks, and archives.
3. Run `tools/export-nas-inventory.ps1` against the mounted share.
4. Review `docs/inventory/generated/nas-candidate-files.csv`.
5. Copy only repo-worthy public-safe files into this repository.
6. Document exclusions and duplicates in `docs/design-and-nas-inventory.md`.
7. Update `docs/inventory/nas-access-log.csv`.
8. Reopen or update issue #1.

## 2. Confirm Unity Asset Cleanup

1. Review `docs/inventory/unity-asset-audit.csv`; it should list only retained project folders.
2. Review `docs/inventory/unity-risky-asset-references.csv` and `docs/inventory/unity-third-party-removal-status.csv`; uncleared downloaded/third-party folders should be absent from the repo and have zero serialized references.
3. Review `docs/inventory/unity-asset-disposition.csv`; every high-risk folder should have `removed_from_repo`.
4. Review `docs/public-asset-manifest.md`, `docs/inventory/unity-public-asset-manifest.csv`, `docs/unity-attribution-gap-report.md`, `docs/inventory/unity-attribution-gap-report.csv`, `docs/public-release-file-plan.md`, and `docs/inventory/public-release-file-plan.csv`.
5. Keep removed third-party/downloaded assets out of the public repo unless written redistribution rights are added later.
6. Update `NOTICE.md`, `docs/third-party-assets.md`, `docs/unity-dependencies.md`, and `docs/asset-disposition-tracker.md` after any future asset changes.
7. Confirm issue #2 is closed with removal evidence.

## 3. Final Unity Validation

Interactive VR smoke testing is deferred by user request on 2026-06-20 and is optional before a VR gameplay release. Keep automated validation current before future release changes.

1. Open `unity/21verse-vr-game-hub` in Unity `2022.3.25f1`.
2. Load and smoke-test the README scenes interactively.
3. Review shader fallback warnings from `docs/unity-validation.md`.
4. Run:

```powershell
.\tools\export-unity-pre-smoke-status.ps1
.\tools\run-unity-scene-validation.ps1
```

5. Close or update issue #3.

## 4. Google Drive/Public Docs

1. Review `docs/inventory/google-drive-release-plan.csv`.
2. Export only redacted public-safe derivatives into `docs/`.
3. Keep `exclude_private` rows out of the public repository.
4. Update `docs/google-drive-inventory.md` and `docs/google-drive-release-plan.md`.

## 5. Final Audit

Run:

```powershell
.\tools\export-unity-asset-audit.ps1
.\tools\export-unity-risky-asset-references.ps1
.\tools\export-unity-asset-replacement-worklist.ps1
.\tools\export-public-asset-manifest.ps1
.\tools\export-unity-attribution-gap-report.ps1
.\tools\export-unity-third-party-removal-status.ps1
.\tools\export-public-release-file-plan.ps1
.\tools\export-google-drive-release-plan.ps1
.\tools\export-google-drive-public-manifest.ps1
.\tools\export-release-blocker-action-plan.ps1
.\tools\export-github-release-state.ps1
.\tools\test-repo-hygiene.ps1
.\tools\run-release-audit.ps1
.\tools\test-github-release-state.ps1
.\tools\test-github-branch-protection.ps1
git status --short --branch
```

Commit any regenerated inventory or audit changes.

## 6. Publication State

The user approved publication on 2026-06-22, and the repository is public at `YYK2007/21verse`.

For future release changes:

1. Confirm GitHub Actions are green on `main`.
2. Confirm `docs/inventory/release-requirements-status.csv` has no `blocked` requirements.
3. Confirm `docs/inventory/release-audit.md` reports no content blockers.
4. Confirm the `Public release readiness` milestone has no open blocker issues.
5. Run `tools\test-github-branch-protection.ps1` and confirm `docs/inventory/github-branch-protection-status.csv` has no `blocked`, `missing`, or `pending_admin_verification` rows.
6. Create a release announcement or tag only after branch protection is verified and Actions are green.
