# Public Release Runbook

This runbook describes the final path from private staging repo to public open-source repository. Do not run the visibility-change step while `docs/inventory/release-audit.md` still reports blockers.

Use `docs/release-evidence-manifest.md` and `docs/inventory/release-requirements-status.csv` as the evidence map for the final review.

## 1. Resolve NAS Review

1. Mount or authenticate to `Youssef Storage` / `WDMyCloudEX4100`.
2. Search for 21Verse files across Unity projects, design files, documents, decks, and archives.
3. Run `tools/export-nas-inventory.ps1` against the mounted share.
4. Review `docs/inventory/generated/nas-candidate-files.csv`.
5. Copy only repo-worthy public-safe files into this repository.
6. Document exclusions and duplicates in `docs/design-and-nas-inventory.md`.
7. Update `docs/inventory/nas-access-log.csv`.
8. Close or update issue #1.

## 2. Resolve Unity Asset Rights

1. Review `docs/inventory/unity-asset-audit.csv`.
2. Review `docs/inventory/unity-risky-asset-references.csv`.
3. Review `docs/unity-external-imports.md` and `docs/inventory/unity-external-imports.csv`.
4. Follow `docs/asset-removal-plan.md`.
5. For every high-risk asset folder, choose one final action:
   - confirm public source redistribution rights,
   - replace with original or verified redistributable assets,
   - remove and document import/acquisition steps.
6. Update `NOTICE.md`, `docs/third-party-assets.md`, `docs/unity-dependencies.md`, and `docs/asset-disposition-tracker.md`.
7. Close or update issue #2.

## 3. Final Unity Validation

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
.\tools\export-google-drive-release-plan.ps1
.\tools\test-repo-hygiene.ps1
.\tools\run-release-audit.ps1
.\tools\test-github-release-state.ps1
git status --short --branch
```

Commit any regenerated inventory or audit changes.

## 6. Visibility Change

Only after all release blockers are resolved:

1. Confirm GitHub Actions are green on `main`.
2. Confirm `docs/inventory/release-requirements-status.csv` has no `blocked` requirements.
3. Confirm `docs/inventory/release-audit.md` reports no blockers.
4. Confirm the `Public release readiness` milestone has no open blocker issues.
5. Confirm `docs/github-branch-protection.md` has been reviewed by a GitHub admin.
6. Remove or update the private-visibility guard in `tools/test-repo-hygiene.ps1` as part of the same reviewed release change.
7. Change GitHub repository visibility from private to public.
8. Create a release announcement or tag only after visibility is public and verified.
