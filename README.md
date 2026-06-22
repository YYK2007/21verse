# 21Verse

21Verse is a Unity VR learning project focused on accessible, immersive educational mini-games.

This repository is the public open-source release of selected 21Verse work. It is not the full private 21Verse project: private research proposals, IRB materials, pitch decks, partner materials, testing data, financials, and unsanitized Drive/NAS files remain excluded unless a separate public-safe derivative is created.

## Project Context

21Verse explores VR learning experiences for people with Down syndrome and adjacent accessibility-focused learning contexts. The public release centers on Unity scene compositions, game logic, and educational interaction patterns that were developed as part of 21Verse. Private Drive research, IRB, pitch, and partner documents are used only as release-review context; their links and raw contents are not included in this repository.

## Open-Source Scope

Included here:

- Curated 21Verse Unity scenes and scripts for learning/gameplay prototypes.
- Selected public-facing 21Verse brand assets.
- Public-safe documentation, release evidence, and exclusion records.

Excluded from this release:

- Private Google Drive docs, pitch decks, IRB files, partner proposals, and research/testing sheets.
- NAS files, by user request, unless that scope is reopened later.
- Downloaded/Asset Store/sample/template Unity asset folders with uncertain redistribution rights.

## Repository Layout

- `unity/21verse-vr-game-hub/` - main Unity project, curated from the latest adjective/color game hub.
- `brand/` - selected public brand images.
- `docs/` - publication notes, inventory, and non-sensitive public-facing collateral.
- `tools/` - reserved for future repo maintenance scripts.

## Unity Project

Open `unity/21verse-vr-game-hub` in Unity Hub using Unity `2022.3.25f1`.

Important scenes live under:

- `Assets/Scenes/MainMenu.unity`
- `Assets/Scenes/WordLevel01.unity`
- `Assets/Scenes/AdjectiveLevel01.unity`
- `Assets/Scenes/IdentifyingColors.unity`
- `Assets/Scenes/NumberLevelUI01.unity`
- `Assets/Scenes/NumberInequalitiesLevel.unity`
- `Assets/Scenes/Cashier.unity`

These listed scenes are 21Verse-developed learning/gameplay scene compositions from the curated project. The scene files, scripts, layout work, and educational interaction structure are treated as 21Verse project work. Downloaded, Asset Store, package sample, template-style, and uncertain-rights Unity asset folders were removed from the repository before public release; old visuals can be reconstructed privately only by reacquiring/importing the relevant assets outside this repo.

Unity-generated folders such as `Library`, `Logs`, `Temp`, `Obj`, `Build`, `Builds`, and `UserSettings` are intentionally excluded.

To rerun the batchmode scene-open validation:

```powershell
.\tools\run-unity-scene-validation.ps1
```

## Release Evidence

Release evidence and retained/excluded material are documented in:

- `docs/open-source-review.md`
- `docs/source-inventory.md`
- `docs/google-drive-inventory.md`
- `docs/google-drive-release-plan.md`
- `docs/design-and-nas-inventory.md`
- `docs/nas-review-runbook.md`
- `docs/nas-review-checklist.md`
- `docs/game-design-summary.md`
- `docs/unity-smoke-test-checklist.md`
- `docs/asset-removal-plan.md`
- `docs/asset-disposition-tracker.md`
- `docs/unity-dependencies.md`
- `docs/unity-external-imports.md`
- `docs/third-party-assets.md`
- `docs/release-readiness.md`
- `docs/release-evidence-manifest.md`
- `docs/public-release-runbook.md`
- `docs/repository-maintenance.md`
- `docs/github-repo-handoff.md`
- `docs/github-metadata.md`
- `docs/github-tracker.md`
- `docs/github-branch-protection.md`
- `docs/inventory/`
- `docs/inventory/release-requirements-status.csv`
- `CONTRIBUTING.md`
- `SECURITY.md`
- `CODE_OF_CONDUCT.md`
- `SUPPORT.md`
- `CHANGELOG.md`
- Unity package dependencies and any newly added third-party Unity asset licenses

To regenerate the Unity asset folder audit:

```powershell
.\tools\export-unity-asset-audit.ps1
.\tools\export-unity-risky-asset-references.ps1
```

To regenerate the Google Drive release decision matrix:

```powershell
.\tools\export-google-drive-release-plan.ps1
```

To scan a mounted NAS share after access is available:

```powershell
.\tools\export-nas-inventory.ps1 -Roots "Z:\"
```

To regenerate the release gate snapshot:

```powershell
.\tools\run-release-audit.ps1
```

To run lightweight repo hygiene checks without opening Unity:

```powershell
.\tools\test-repo-hygiene.ps1
```

To verify the GitHub repository state from this Windows session:

```powershell
.\tools\test-github-release-state.ps1
```

GitHub release tracker issues:

- [#1 Review 21Verse files on Youssef Storage NAS](https://github.com/YYK2007/21verse/issues/1)
- [#2 Confirm third-party Unity asset redistribution rights](https://github.com/YYK2007/21verse/issues/2)
- [#3 Open curated Unity project and smoke test main scenes](https://github.com/YYK2007/21verse/issues/3)
- [#5 Verify GitHub branch protection before public release](https://github.com/YYK2007/21verse/issues/5)

## License

Code and 21Verse-developed scene compositions are staged under the MIT License in `LICENSE` unless another file-level notice says otherwise. Brand assets, screenshots, presentations, and any future third-party Unity assets may have separate ownership or license terms; see `NOTICE.md` and `docs/open-source-review.md`.
