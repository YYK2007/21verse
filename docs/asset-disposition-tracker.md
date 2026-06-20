# Unity Asset Disposition Tracker

This tracker turns the third-party asset audit into folder-level release decisions. It is the working checklist for GitHub issue #2.

Source inventories:

- `docs/inventory/unity-asset-audit.csv`
- `docs/inventory/unity-risky-asset-references.csv`
- `docs/inventory/unity-asset-disposition.csv`
- `docs/inventory/unity-external-imports.csv`
- `docs/inventory/unity-asset-replacement-worklist.csv`
- `docs/inventory/unity-public-asset-manifest.csv`
- `docs/inventory/unity-attribution-gap-report.csv`
- `docs/inventory/unity-third-party-removal-status.csv`
- `docs/public-asset-manifest.md`
- `docs/unity-attribution-gap-report.md`

## Policy

- `pending` means the folder must not be treated as public-release-ready.
- Asset Store, Unity sample/template, publisher-style, downloaded-looking, or unknown-origin assets should be removed, replaced, or documented as external import steps unless redistribution rights are confirmed.
- After each folder decision, regenerate the Unity asset inventories and rerun scene validation.
- Update `NOTICE.md` only after final retained third-party assets are known.
- Remove downloaded/third-party folders only after `docs/inventory/unity-third-party-removal-status.csv` shows they have no serialized references, or after the listed references have been replaced/removed.

## Folder Decisions

| Folder | Current default | Release decision | Replacement or import path |
| --- | --- | --- | --- |
| `Assets/Fantasy Skybox FREE` | Do not bundle unless redistribution rights are confirmed. | `pending` | Replace scene skybox/material references with original or verified redistributable sky assets, or document exact Asset Store import steps. |
| `Assets/WOC` | Confirm source and redistribution rights; otherwise replace/remove. | `pending` | Replace referenced models/textures with original placeholders or verified redistributable environment assets. |
| `Assets/Samples` | Prefer documenting package sample import instead of bundling. | `pending` | Document Unity Package Manager package/sample import steps, then rebind affected prefabs/scenes to imported package assets or local replacements. |
| `Assets/Lana Studio` | Confirm source and redistribution rights; otherwise replace/remove. | `pending` | Replace visual effects/assets in affected learning scenes with original or verified redistributable assets. |
| `Assets/Sprites` | Keep only original or verified redistributable sprites. | `pending` | Review sprite source/ownership, replace uncertain UI art with original project art, and retain only public-safe sprites. |
| `Assets/BuildingMaterials` | Replace uncertain materials before public release. | `pending` | Replace textures/materials in Education Building prefab and Cashier scene with original or verified redistributable materials. |
| `Assets/Fresh_Raystore` | Do not bundle unless redistribution rights are confirmed. | `pending` | Replace cashier shelving/store prop with original or verified redistributable prop, or document exact Asset Store import steps. |
| `Assets/TextMesh Pro` | Prefer Unity package dependency and retain required font licenses. | `pending` | Move toward UPM-provided TextMesh Pro assets where practical; keep LiberationSans license if any bundled font remains. |
| `Assets/VRTemplateAssets` | Confirm template/sample redistribution terms or document import steps. | `pending` | Document Unity template/sample import steps or replace template prefabs with project-owned XR setup assets. |

## Completion Rule

Use `docs/unity-external-imports.md` to decide whether each unresolved folder is imported externally, replaced, removed, or retained with confirmed rights.
Use `docs/public-asset-manifest.md` for the generated keep/exclude/replacement map that should guide the eventual public branch cut.

Issue #2 can close only when every row in `docs/inventory/unity-asset-disposition.csv` has a non-`pending` `release_decision`, the resulting asset/reference inventories have been regenerated, `NOTICE.md` reflects retained third-party material, and Unity scene validation still passes.
