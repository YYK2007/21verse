# Unity External Import Handoff

This handoff records how currently bundled Unity asset folders should be treated if the public release removes third-party or uncertain-origin assets from the repository.

It does not grant redistribution rights. Use it as an acquisition/import map for GitHub issue #2, then update `NOTICE.md` and the asset disposition tracker after final decisions are made.

Machine-readable rows live in `docs/inventory/unity-external-imports.csv`.

## Import Decision Rules

- `import_from_unity_registry` means the asset should come from a package already declared in `unity/21verse-vr-game-hub/Packages/manifest.json`.
- `import_from_asset_store` means the repo contains evidence pointing to Unity Asset Store origin, but public GitHub redistribution still needs explicit confirmation or removal.
- `replace_or_confirm_source` means no reliable public acquisition path was found in the repo scan.
- `replace_with_project_owned` means the public repo should prefer original 21Verse replacements unless source ownership can be proven.

## External Import Map

| Asset folder | Source evidence | Preferred public-release treatment |
| --- | --- | --- |
| `Assets/Fantasy Skybox FREE` | `Readme.txt` identifies Fantasy Skybox FREE `1.6.5`, links Unity Asset Store package `18353`, and release notes show Unity compatibility history. | Remove from public repo unless redistribution rights are confirmed; document Asset Store import and rebind skybox/material references after import. |
| `Assets/Fresh_Raystore` | `Fresh_shelving_Package.txt` thanks the downloader and links Unity Asset Store publisher `1455`. | Remove from public repo unless redistribution rights are confirmed; document Asset Store/publisher acquisition and rebind the Cashier scene prop after import. |
| `Assets/Samples` | Folder matches XR Interaction Toolkit sample-style content, and the manifest pins `com.unity.xr.interaction.toolkit` `3.1.2`. | Prefer importing samples from the Unity Package Manager package instead of bundling them. |
| `Assets/TextMesh Pro` | Manifest pins `com.unity.textmeshpro` `3.0.9`; bundled font license exists at `Assets/TextMesh Pro/Fonts/LiberationSans - OFL.txt`. | Prefer the Unity Package Manager TextMesh Pro package; retain font licenses for any bundled fonts that remain. |
| `Assets/VRTemplateAssets` | Folder appears to be Unity VR template/sample-style content; manifest pins XR packages including XR Interaction Toolkit, XR Management, and OpenXR. | Confirm template terms or recreate the XR rig/project-owned setup, then revalidate scenes. |
| `Assets/WOC` | Large model/texture pack; no license or readme evidence found in the repo scan. | Confirm source and rights, or replace with project-owned/redistributable environment assets. |
| `Assets/Lana Studio` | Publisher-style folder name; no license or readme evidence found in the repo scan. | Confirm source and rights, or replace affected effects/assets. |
| `Assets/BuildingMaterials` | Downloaded-looking material and texture filenames; no license/readme evidence found in the repo scan. | Replace with project-owned or verified redistributable materials before public release. |
| `Assets/Sprites` | Hundreds of sprite files with unknown ownership. | Keep only sprites with proven 21Verse ownership or verified redistributable rights; replace the rest. |

## Validation After Import or Replacement

After any folder is removed, imported, or replaced:

1. Reopen `unity/21verse-vr-game-hub` in Unity `2022.3.25f1`.
2. Regenerate `docs/inventory/unity-asset-audit.csv`.
3. Regenerate `docs/inventory/unity-risky-asset-references.csv`.
4. Run `tools/run-unity-scene-validation.ps1`.
5. Smoke-test the README scenes and update `docs/inventory/unity-smoke-test-status.csv`.
6. Update `docs/inventory/unity-asset-disposition.csv` with the final non-`pending` release decision.
