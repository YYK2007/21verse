# Third-Party Asset Register

This register is based on the Unity asset cleanup performed for `unity/21verse-vr-game-hub/Assets`.

It is not legal advice. Treat any future third-party asset addition as needing owner/license confirmation before release-scope changes are published.

The main learning/gameplay scene compositions under `Assets/Scenes` are 21Verse-developed project work. This register focuses on referenced visual, template, package, sample, and downloaded assets that may be embedded in or linked from those scenes.

For Unity Package Manager dependencies and a public-release handoff plan, see `docs/unity-dependencies.md`.
For the external import/removal handoff, see `docs/unity-external-imports.md` and `docs/inventory/unity-external-imports.csv`.
For the machine-readable folder audit, see `docs/inventory/unity-asset-audit.csv`.
For serialized scene/prefab reference impact and removal sequencing, see `docs/asset-removal-plan.md`, `docs/inventory/unity-risky-asset-references.csv`, and `docs/inventory/unity-asset-replacement-worklist.csv`.
For folder-level release decisions, see `docs/asset-disposition-tracker.md` and `docs/inventory/unity-asset-disposition.csv`.
For NOTICE and attribution gaps, see `docs/unity-attribution-gap-report.md` and `docs/inventory/unity-attribution-gap-report.csv`.
For deletion safety after the 2026-06-20 downloaded-asset cleanup, see `docs/inventory/unity-third-party-removal-status.csv`.

## Removed High-Risk Asset Folders

The following folders were removed from the repository rather than redistributed publicly:

| Asset folder | Evidence found | Public-release action |
| --- | --- | --- |
| `Assets/WOC` | Large model/texture pack, no license/readme found in repo scan | Removed from repo; replace with original or verified redistributable environment assets if rebuilt. |
| `Assets/Fantasy Skybox FREE` | `Readme.txt`, `ReleaseNotes.txt`, Unity Asset Store metadata | Removed from repo; reacquire/import privately if old skybox visuals are needed. |
| `Assets/VRTemplateAssets` | Unity/VR template content, some `licenseType: Pro` metadata | Removed from repo; reconstruct through Unity template/package setup only if needed. |
| `Assets/BuildingMaterials` | Material/texture filenames include downloaded texture names | Removed from repo; add only original or verified redistributable materials going forward. |
| `Assets/Lana Studio` | Publisher-style folder name, no license/readme found in repo scan | Removed from repo; replace with original or verified redistributable effects if needed. |
| `Assets/Fresh_Raystore` | `Fresh_shelving_Package.txt`, Unity Asset Store metadata, publisher link | Removed from repo; reacquire/import privately if old cashier props are needed. |
| `Assets/TextMesh Pro` | Unity/TextMesh Pro files plus `LiberationSans - OFL.txt` | Removed from repo; rely on the Unity Package Manager package unless font files are deliberately reintroduced with notices. |
| `Assets/Samples` | XR Interaction Toolkit sample assets | Removed from repo; reconstruct through Unity Package Manager samples only if needed. |

## Lower-Risk Original/Project Folders

These appear more project-specific but still deserve review:

- `Assets/Scripts`
- `Assets/Scenes`
- `Assets/IdentifyingColors`
- `Assets/Comparision2D`
- `Assets/Prefabs`
- `Assets/XR`
- `Assets/XRI`
- `Assets/Settings`

## Recommended Public-Release Policy

1. Keep source code, 21Verse-developed scene compositions, project prefabs, and original 21Verse assets in the repo.
2. Keep asset-store/downloaded packs out of the repo unless their license explicitly permits public source redistribution.
3. For removed packs, document private acquisition/import steps only when the project deliberately supports reconstruction.
4. Keep generated Unity folders excluded through `.gitignore`.
5. Keep Git LFS for all binary assets that remain.

## Scan Notes

The machine-readable audit currently covers the retained top-level folders under `Assets`, including file counts, approximate size, Unity `.meta` `licenseType` values, evidence files, and the recommended public-release action.
The risky reference audit and removal-status inventory record the removed high-risk folders with zero serialized references to bundled folders still present in the repo.

The removed folders previously included Asset Store metadata, Unity sample/template-style files, and downloaded-looking material filenames. They are intentionally absent from the public-ready source tree.
