# Asset Removal and Replacement Plan

This plan is for preparing a future public repository without redistributing third-party or uncertain-rights Unity assets.

Source audits:

- `docs/inventory/unity-asset-audit.csv`
- `docs/inventory/unity-risky-asset-references.csv`
- `docs/inventory/unity-asset-disposition.csv`
- `docs/inventory/unity-asset-replacement-worklist.csv`

Regenerate them with:

```powershell
.\tools\export-unity-asset-audit.ps1
.\tools\export-unity-risky-asset-references.ps1
.\tools\export-unity-asset-replacement-worklist.ps1
```

## Current Finding

The high-risk bundled asset folders have now been removed from the repository after the generated risky-reference inventory reported zero serialized references to folders still present in the repo. Unity batchmode validation was rerun after removal and the README scenes still open with zero missing script references.

Use `docs/inventory/unity-asset-replacement-worklist.csv` as the reconstruction/import handoff. It now records removed folders rather than active replacement blockers.

## Folder-Level Plan

| Folder | External references found | Public-release plan |
| --- | ---: | --- |
| `Assets/Fantasy Skybox FREE` | 0 | Removed from repo; reacquire/import privately only if old skybox visuals are needed. |
| `Assets/WOC` | 0 | Removed from repo; replace with original or verified redistributable environment assets if visuals are rebuilt. |
| `Assets/Samples` | 0 | Removed from repo; reconstruct through Unity Package Manager samples only if needed. |
| `Assets/Lana Studio` | 0 | Removed from repo; replace with original or verified redistributable effects if needed. |
| `Assets/Sprites` | 0 | Removed from repo; add only original 21Verse or verified redistributable UI art going forward. |
| `Assets/BuildingMaterials` | 0 | Removed from repo; add only original or verified redistributable materials going forward. |
| `Assets/Fresh_Raystore` | 0 | Removed from repo; reacquire/import privately only if the old cashier prop is needed. |
| `Assets/TextMesh Pro` | 0 | Removed from repo; rely on the Unity Package Manager package unless bundled font files are deliberately reintroduced with notices. |
| `Assets/VRTemplateAssets` | 0 | Removed from repo; reconstruct through Unity template/package setup only if needed. |

## Suggested Sequence

1. Keep removed third-party/downloaded folders out of Git.
2. If old visuals are needed privately, reacquire/import them outside the public repo.
3. If visuals are rebuilt for public release, use original 21Verse or verified redistributable assets.
4. Run:

```powershell
.\tools\export-unity-asset-audit.ps1
.\tools\export-unity-risky-asset-references.ps1
.\tools\export-unity-asset-replacement-worklist.ps1
.\tools\run-unity-scene-validation.ps1
.\tools\run-release-audit.ps1
```

5. Update `docs/inventory/unity-asset-disposition.csv`, `NOTICE.md`, `docs/third-party-assets.md`, and issue #2 after any future asset change.
