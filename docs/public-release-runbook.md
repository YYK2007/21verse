# Public Release Runbook

This runbook describes the final path from private staging repo to public open-source repository. Do not run the visibility-change step while `docs/inventory/release-audit.md` still reports blockers.

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
3. Follow `docs/asset-removal-plan.md`.
4. For every high-risk asset folder, choose one final action:
   - confirm public source redistribution rights,
   - replace with original or verified redistributable assets,
   - remove and document import/acquisition steps.
5. Update `NOTICE.md`, `docs/third-party-assets.md`, and `docs/unity-dependencies.md`.
6. Close or update issue #2.

## 3. Final Unity Validation

1. Open `unity/21verse-vr-game-hub` in Unity `2022.3.25f1`.
2. Load and smoke-test the README scenes interactively.
3. Review shader fallback warnings from `docs/unity-validation.md`.
4. Run:

```powershell
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
git status --short --branch
```

Commit any regenerated inventory or audit changes.

## 6. Visibility Change

Only after all release blockers are resolved:

1. Confirm GitHub Actions are green on `main`.
2. Confirm `docs/inventory/release-audit.md` reports no blockers.
3. Confirm the `Public release readiness` milestone has no open blocker issues.
4. Change GitHub repository visibility from private to public.
5. Create a release announcement or tag only after visibility is public and verified.
