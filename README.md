# 21Verse

21Verse is a Unity VR learning project focused on immersive educational mini-games.

This repository is prepared as the private staging repo for an eventual open-source release. It currently contains the curated Unity project, selected brand/public-facing assets, and review notes for materials that should stay private until they are explicitly sanitized.

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

Unity-generated folders such as `Library`, `Logs`, `Temp`, `Obj`, `Build`, `Builds`, and `UserSettings` are intentionally excluded.

To rerun the batchmode scene-open validation:

```powershell
.\tools\run-unity-scene-validation.ps1
```

## Before Public Release

This repo is private-ready, not public-published. Before changing visibility to public, review:

- `docs/open-source-review.md`
- `docs/source-inventory.md`
- `docs/google-drive-inventory.md`
- `docs/design-and-nas-inventory.md`
- `docs/game-design-summary.md`
- `docs/unity-dependencies.md`
- `docs/third-party-assets.md`
- `docs/release-readiness.md`
- `docs/github-private-repo.md`
- `docs/inventory/`
- third-party Unity asset licenses under `unity/21verse-vr-game-hub/Assets`

Private GitHub tracker issues:

- [#1 Review 21Verse files on Youssef Storage NAS](https://github.com/YYK2007/21verse_opensource/issues/1)
- [#2 Confirm third-party Unity asset redistribution rights](https://github.com/YYK2007/21verse_opensource/issues/2)
- [#3 Open curated Unity project and smoke test main scenes](https://github.com/YYK2007/21verse_opensource/issues/3)

## License

Code is staged under the MIT License in `LICENSE`. Brand assets, screenshots, presentations, and third-party Unity assets may have separate ownership or license terms; see `NOTICE.md` and `docs/open-source-review.md`.
