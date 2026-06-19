# Unity Dependencies and Asset Handoff

This file separates reconstructable Unity Package Manager dependencies from bundled asset folders that need rights review before a public release.

## Unity Version

- Editor: `2022.3.25f1`
- Project path: `unity/21verse-vr-game-hub`
- Package manifest: `unity/21verse-vr-game-hub/Packages/manifest.json`
- Package lock: `unity/21verse-vr-game-hub/Packages/packages-lock.json`
- Bundled asset audit: `docs/inventory/unity-asset-audit.csv`

## Direct Unity Package Manager Dependencies

These are declared in `Packages/manifest.json` and can be restored by Unity from the Unity registry or built-in package set:

| Package | Version |
| --- | --- |
| `com.unity.collab-proxy` | `2.9.3` |
| `com.unity.feature.development` | `1.0.1` |
| `com.unity.feature.vr` | `1.0.0` |
| `com.unity.inputsystem` | `1.13.1` |
| `com.unity.learn.iet-framework` | `4.0.4` |
| `com.unity.probuilder` | `5.2.4` |
| `com.unity.render-pipelines.universal` | `14.0.11` |
| `com.unity.terrain-tools` | `5.0.6` |
| `com.unity.textmeshpro` | `3.0.9` |
| `com.unity.timeline` | `1.7.7` |
| `com.unity.toolchain.win-x86_64-linux-x86_64` | `2.0.11` |
| `com.unity.visualscripting` | `1.9.2` |
| `com.unity.xr.interaction.toolkit` | `3.1.2` |
| `com.unity.xr.management` | `4.5.1` |
| `com.unity.xr.openxr` | `1.14.1` |

The `com.unity.modules.*` entries in the manifest are built-in Unity modules and are not listed here individually.

## Bundled Asset Folders Requiring Release Decisions

These folders are committed in the private staging repo today. Before making the repository public, either confirm their redistribution rights in writing, replace them, or remove them and document import steps.

The source CSV for this table is regenerated with:

```powershell
.\tools\export-unity-asset-audit.ps1
```

| Folder | Evidence in repo | Recommended public-release treatment |
| --- | --- | --- |
| `Assets/Fantasy Skybox FREE` | Readme/release notes identify it as a free Unity Asset Store package, version `1.6.5`; `.meta` files include `licenseType: Store`. | Do not assume public GitHub redistribution is allowed. Prefer remove and document Asset Store import, unless redistribution rights are confirmed. |
| `Assets/Fresh_Raystore` | Package note points to a Unity Asset Store publisher page. | Treat as Asset Store content. Prefer remove and document import, unless redistribution rights are confirmed. |
| `Assets/WOC` | Large model/texture pack with no license/readme found in the repo scan. | Confirm origin and rights. If unknown, replace or remove before public release. |
| `Assets/Lana Studio` | Publisher-style folder name with no license/readme found in the repo scan. | Confirm origin and rights. If unknown, replace or remove before public release. |
| `Assets/BuildingMaterials` | Contains downloaded-looking texture filenames, including marble/wood image assets. | Replace with original materials or verified redistributable textures before public release. |
| `Assets/Samples` | XR Interaction Toolkit sample content. | Prefer documenting Unity Package Manager sample import steps instead of bundling sample content. |
| `Assets/VRTemplateAssets` | Unity VR template-style assets. | Confirm whether these are Unity template/sample assets and whether bundling is permitted; otherwise document template import steps. |
| `Assets/TextMesh Pro` | Includes TextMesh Pro assets and `LiberationSans - OFL.txt`. | Keep the font license with any retained font assets; prefer relying on the UPM package where possible. |

## Suggested Cleanup Path

1. Keep project-specific folders such as `Assets/Scripts`, `Assets/Scenes`, `Assets/Prefabs`, `Assets/Sprites`, `Assets/XR`, `Assets/XRI`, `Assets/Settings`, `Assets/IdentifyingColors`, and `Assets/Comparision2D`.
2. For each Asset Store/downloaded folder, decide: confirmed redistributable, replace with original placeholder, or remove and document install/import instructions.
3. After removals or replacements, reopen the project in Unity `2022.3.25f1`, let it reimport, and smoke-test the scenes in `README.md`.
4. Update `NOTICE.md`, `docs/third-party-assets.md`, and GitHub issue #2 with the final decision for each folder.
