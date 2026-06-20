# Unity Asset Disposition Tracker

This tracker records the folder-level release decisions for the third-party/downloaded Unity asset cleanup. It is the closing evidence for GitHub issue #2.

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
- `removed_from_repo` means the folder is intentionally absent from the public source tree.
- Asset Store, Unity sample/template, publisher-style, downloaded-looking, or unknown-origin assets should be removed, replaced, or documented as external import steps unless redistribution rights are confirmed.
- After each folder decision, regenerate the Unity asset inventories and rerun scene validation.
- Keep removed downloaded/third-party folders out of the repository unless redistribution rights are later confirmed in writing.
- Update `NOTICE.md` if any third-party assets are added back later.

## Folder Decisions

| Folder | Current default | Release decision | Replacement or import path |
| --- | --- | --- | --- |
| `Assets/Fantasy Skybox FREE` | Do not bundle unless redistribution rights are confirmed. | `removed_from_repo` | Old skybox visuals can be reconstructed privately by reacquiring/importing the package; keep the public repo free of bundled files. |
| `Assets/WOC` | Unknown-origin model/texture pack. | `removed_from_repo` | Replace with original or verified redistributable environment assets if the visuals are rebuilt. |
| `Assets/Samples` | Prefer Unity Package Manager sample import instead of bundling. | `removed_from_repo` | Reconstruct through Unity Package Manager samples only if needed privately. |
| `Assets/Lana Studio` | Publisher-style folder with no license/readme evidence. | `removed_from_repo` | Replace with original or verified redistributable visual effects if needed. |
| `Assets/Sprites` | Keep only original or verified redistributable sprites. | `removed_from_repo` | Add only original 21Verse or verified redistributable UI art going forward. |
| `Assets/BuildingMaterials` | Downloaded-looking material/texture folder. | `removed_from_repo` | Add only original or verified redistributable materials going forward. |
| `Assets/Fresh_Raystore` | Asset Store cashier/store prop package. | `removed_from_repo` | Reacquire/import privately if the old prop is needed; do not bundle public files without rights. |
| `Assets/TextMesh Pro` | Prefer Unity package dependency. | `removed_from_repo` | Use the UPM TextMesh Pro package; keep font/license notices if bundled font files are ever reintroduced. |
| `Assets/VRTemplateAssets` | Unity VR template/sample-style assets. | `removed_from_repo` | Reconstruct through Unity template/package setup only if needed privately. |

## Completion Rule

Use `docs/unity-external-imports.md` to decide whether each unresolved folder is imported externally, replaced, removed, or retained with confirmed rights.
Use `docs/public-asset-manifest.md` for the generated keep/exclude/replacement map that should guide the eventual public branch cut.

Issue #2 can stay closed while every row in `docs/inventory/unity-asset-disposition.csv` has a non-`pending` `release_decision`, removed folders stay out of the repo, regenerated inventories show no public asset exclusions, `NOTICE.md` reflects the retained scope, and Unity scene validation still passes.
