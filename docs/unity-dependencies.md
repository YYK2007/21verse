# Unity Dependencies and Asset Handoff

This file separates reconstructable Unity Package Manager dependencies from removed asset folders that should not be redistributed in the public source tree without rights evidence.

## Unity Version

- Editor: `2022.3.25f1`
- Project path: `unity/21verse-vr-game-hub`
- Package manifest: `unity/21verse-vr-game-hub/Packages/manifest.json`
- Package lock: `unity/21verse-vr-game-hub/Packages/packages-lock.json`
- Bundled asset audit: `docs/inventory/unity-asset-audit.csv`
- Risky asset reference audit: `docs/inventory/unity-risky-asset-references.csv`
- External import handoff: `docs/unity-external-imports.md` and `docs/inventory/unity-external-imports.csv`

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

## Removed Asset Folders

These folders were present in the pre-release project and were removed from the repository for public-release readiness. Reacquire/import them privately only if old visuals are needed, or replace them with original/verified redistributable assets.

The source CSV for this table is regenerated with:

```powershell
.\tools\export-unity-asset-audit.ps1
.\tools\export-unity-risky-asset-references.ps1
```

| Folder | Evidence found before removal | Public-release treatment |
| --- | --- | --- |
| `Assets/Fantasy Skybox FREE` | Readme/release notes identify it as a free Unity Asset Store package, version `1.6.5`; `.meta` files include `licenseType: Store`. | Removed from repo; do not bundle unless redistribution rights are confirmed. |
| `Assets/Fresh_Raystore` | Package note points to a Unity Asset Store publisher page. | Removed from repo; do not bundle unless redistribution rights are confirmed. |
| `Assets/WOC` | Large model/texture pack with no license/readme found in the repo scan. | Removed from repo; replace with original or verified redistributable assets if rebuilt. |
| `Assets/Lana Studio` | Publisher-style folder name with no license/readme found in the repo scan. | Removed from repo; replace with original or verified redistributable assets if rebuilt. |
| `Assets/BuildingMaterials` | Contains downloaded-looking texture filenames, including marble/wood image assets. | Removed from repo; add only original or verified redistributable textures/materials. |
| `Assets/Samples` | XR Interaction Toolkit sample content. | Removed from repo; reconstruct through Unity Package Manager samples only if needed. |
| `Assets/VRTemplateAssets` | Unity VR template-style assets. | Removed from repo; reconstruct through Unity template/package setup only if needed. |
| `Assets/TextMesh Pro` | Includes TextMesh Pro assets and `LiberationSans - OFL.txt`. | Removed from repo; rely on the UPM package unless bundled font files are deliberately reintroduced with notices. |

## Suggested Cleanup Path

1. Keep project-specific folders such as `Assets/Scripts`, `Assets/Scenes`, `Assets/Prefabs`, `Assets/XR`, `Assets/XRI`, `Assets/Settings`, `Assets/IdentifyingColors`, and `Assets/Comparision2D`.
2. Keep removed Asset Store/downloaded/sample/template-style folders out of Git unless redistribution rights are confirmed in writing.
3. After any future asset addition or replacement, reopen the project in Unity `2022.3.25f1`, let it reimport, and smoke-test the scenes in `README.md`.
4. Update `NOTICE.md`, `docs/third-party-assets.md`, and GitHub issue #2 evidence if third-party assets are ever reintroduced.
