# Third-Party Asset Register

This register is based on files currently included under `unity/21verse-vr-game-hub/Assets`.

It is not legal advice. Treat every item below as needing owner/license confirmation before the repository is made public.

For Unity Package Manager dependencies and a public-release handoff plan, see `docs/unity-dependencies.md`.
For the machine-readable folder audit, see `docs/inventory/unity-asset-audit.csv`.
For serialized scene/prefab reference impact and removal sequencing, see `docs/asset-removal-plan.md` and `docs/inventory/unity-risky-asset-references.csv`.

## High-Priority Review Items

| Asset folder | Approx. size | Evidence found | Public-release action |
| --- | ---: | --- | --- |
| `Assets/WOC` | 166.6 MB | Large model/texture pack, no license/readme found in repo scan | Confirm source and redistribution terms, or remove/replace before public release. |
| `Assets/Fantasy Skybox FREE` | 133.5 MB | `Readme.txt`, `ReleaseNotes.txt`, Unity Asset Store metadata | Confirm Unity Asset Store redistribution terms. Consider documenting as an install dependency instead of bundling. |
| `Assets/VRTemplateAssets` | 73.3 MB | Unity/VR template content, some `licenseType: Pro` metadata | Confirm whether content is original, Unity sample, or store content. |
| `Assets/BuildingMaterials` | 39.1 MB | Material/texture filenames include downloaded texture names | Confirm texture source and redistribution terms. Replace with original placeholders if uncertain. |
| `Assets/Lana Studio` | 11.6 MB | Publisher-style folder name, no license/readme found in repo scan | Confirm source and redistribution terms. |
| `Assets/Fresh_Raystore` | 4.8 MB | `Fresh_shelving_Package.txt`, Unity Asset Store metadata, publisher link | Confirm Unity Asset Store redistribution terms. Consider documenting as dependency instead of bundling. |
| `Assets/TextMesh Pro` | 3.4 MB | Unity/TextMesh Pro files plus `LiberationSans - OFL.txt` | Usually Unity package/sample content, but keep the font license and confirm bundled package terms. |
| `Assets/Samples` | 8.9 MB | XR Interaction Toolkit sample assets | Prefer requiring Unity Package Manager samples or document exact package/sample import steps. |

## Lower-Risk Original/Project Folders

These appear more project-specific but still deserve review:

- `Assets/Scripts`
- `Assets/Scenes`
- `Assets/IdentifyingColors`
- `Assets/Comparision2D`
- `Assets/Prefabs`
- `Assets/Sprites`
- `Assets/XR`
- `Assets/XRI`
- `Assets/Settings`

## Recommended Public-Release Policy

1. Keep source code, scenes, prefabs, and original 21Verse assets in the repo.
2. Remove asset-store/downloaded packs unless their license explicitly permits public source redistribution.
3. For removed packs, document exact acquisition/import steps in `README.md` or a future `docs/dependencies.md`.
4. Keep generated Unity folders excluded through `.gitignore`.
5. Keep Git LFS for all binary assets that remain.

## Scan Notes

The machine-readable audit currently covers 18 top-level folders under `Assets`, including file counts, approximate size, Unity `.meta` `licenseType` values, evidence files, and the recommended public-release action.
The risky reference audit confirms every high-priority bundled asset folder is referenced by scenes, prefabs, or materials, so removals need a Unity replacement pass rather than filesystem deletion.

The scan found license/readme-style files only in:

- `Assets/Fantasy Skybox FREE/Readme.txt`
- `Assets/Fantasy Skybox FREE/ReleaseNotes.txt`
- `Assets/TextMesh Pro/Fonts/LiberationSans - OFL.txt`

Several `.meta` files include `licenseType: Store` or `licenseType: Pro`, which is a warning sign for public redistribution review.
