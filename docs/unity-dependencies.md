# Unity Dependencies

The selected Unity project is configured for Unity `2022.3.25f1`.

## Project Files

- Project path: `unity/21verse-vr-game-hub`
- Package manifest: `unity/21verse-vr-game-hub/Packages/manifest.json`
- Package lock: `unity/21verse-vr-game-hub/Packages/packages-lock.json`
- Unity version file: `unity/21verse-vr-game-hub/ProjectSettings/ProjectVersion.txt`

## Direct Unity Package Manager Dependencies

These packages are declared in `Packages/manifest.json` and can be restored by Unity:

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

The `com.unity.modules.*` entries are built-in Unity modules.

## Updating Dependencies

Update Unity Package Manager dependencies from Unity, then run:

```powershell
.\tools\test-repo-hygiene.ps1
.\tools\run-unity-scene-validation.ps1
```

If an update changes scene behavior, also run a manual Unity/VR smoke check.
