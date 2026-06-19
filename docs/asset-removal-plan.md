# Asset Removal and Replacement Plan

This plan is for preparing a future public repository without redistributing third-party or uncertain-rights Unity assets.

Source audits:

- `docs/inventory/unity-asset-audit.csv`
- `docs/inventory/unity-risky-asset-references.csv`
- `docs/inventory/unity-asset-disposition.csv`

Regenerate them with:

```powershell
.\tools\export-unity-asset-audit.ps1
.\tools\export-unity-risky-asset-references.ps1
```

## Current Finding

Every high-risk bundled asset folder has serialized references from scenes, prefabs, or materials. Do not delete these folders blindly. Remove or replace them in Unity, rerun scene validation, and confirm all README scenes still open with zero missing scripts or broken material references.

## Folder-Level Plan

| Folder | External references found | Public-release plan |
| --- | ---: | --- |
| `Assets/Fantasy Skybox FREE` | 7 | Used by all main scenes. Replace skyboxes/material references with original or verified redistributable sky assets, or document Asset Store import steps and keep the public repo free of the package. |
| `Assets/WOC` | 6 | Used by most main scenes. Confirm source/rights; otherwise replace models/textures with original placeholders before public release. |
| `Assets/Samples` | 19 | Used by all main scenes and many `VRTemplateAssets` prefabs. Prefer Unity Package Manager sample import instructions, then verify all XR prefab and scene references. |
| `Assets/Lana Studio` | 4 | Used by several learning scenes. Confirm source/rights; otherwise replace visual effects/assets or remove dependent scene objects. |
| `Assets/Sprites` | 4 | Used by `MainMenu`, `WordLevel01`, `AdjectiveLevel01`, and `NumberInequalitiesLevel`. Review ownership and replace any non-original UI art. |
| `Assets/BuildingMaterials` | 2 | Used by `Assets/Education Building.prefab` and `Assets/Scenes/Cashier.unity`. Replace downloaded-looking textures with original or verified redistributable materials. |
| `Assets/Fresh_Raystore` | 1 | Used by `Assets/Scenes/Cashier.unity`. Treat as Asset Store content; replace cashier scene shelving/store prop or document import steps. |
| `Assets/TextMesh Pro` | 13 | Used by scenes, `BuildingMaterials`, and `VRTemplateAssets`. Prefer UPM/TextMesh Pro package assets and retain font licenses for any bundled fonts. |
| `Assets/VRTemplateAssets` | 1 | Used by `Assets/Scenes/SampleScene.unity`; also depends on `Assets/Samples`. Confirm template/sample redistribution rights or document template import steps. |

## Suggested Sequence

1. Duplicate the private staging repo or work on a private cleanup branch.
2. Start with Asset Store or sample packages that can be documented as dependencies: `Fantasy Skybox FREE`, `Fresh_Raystore`, `Samples`, and possibly `VRTemplateAssets`.
3. Replace scene references with placeholders or Unity Package Manager/sample imports.
4. Replace uncertain downloaded materials in `BuildingMaterials`.
5. Confirm whether `WOC`, `Lana Studio`, and `Sprites` are original, licensed, or replaceable.
6. Run:

```powershell
.\tools\export-unity-asset-audit.ps1
.\tools\export-unity-risky-asset-references.ps1
.\tools\run-unity-scene-validation.ps1
.\tools\run-release-audit.ps1
```

7. Update `docs/inventory/unity-asset-disposition.csv`, `NOTICE.md`, `docs/third-party-assets.md`, and issue #2 with the final decision for each folder.
