# Unity Validation

Status as of 2026-06-22: the selected Unity project opens in Unity batchmode, and all configured project scenes validate with zero missing script components.

## Environment

- Unity editor: `2022.3.25f1`
- Project: `unity/21verse-vr-game-hub`
- Scene validation command: `tools/run-unity-scene-validation.ps1`

## Scene Validation

`SceneValidation.ValidateConfiguredScenes` opens each configured scene in Unity batchmode and checks for missing script components.

| Scene | Result | Root objects | GameObjects |
| --- | --- | ---: | ---: |
| `Assets/Scenes/MainMenu.unity` | Opened successfully; 0 missing scripts | 11 | 30 |
| `Assets/Scenes/WordLevel01.unity` | Opened successfully; 0 missing scripts | 9 | 30 |
| `Assets/Scenes/AdjectiveLevel01.unity` | Opened successfully; 0 missing scripts | 9 | 26 |
| `Assets/Scenes/IdentifyingColors.unity` | Opened successfully; 0 missing scripts | 9 | 21 |
| `Assets/Scenes/NumberLevelUI01.unity` | Opened successfully; 0 missing scripts | 9 | 37 |
| `Assets/Scenes/NumberInequalitiesLevel.unity` | Opened successfully; 0 missing scripts | 9 | 32 |
| `Assets/Scenes/Cashier.unity` | Opened successfully; 0 missing scripts | 10 | 32 |

## Running Validation

From the repository root:

```powershell
.\tools\run-unity-scene-validation.ps1
```

The script finds the Unity editor, opens `unity/21verse-vr-game-hub`, runs the configured scene validator, and writes a log to the path printed by the command.

## Manual Checks

Batchmode validation confirms structural scene health. Gameplay, headset comfort, controller feel, audio prompts, visual clarity, and learner-facing flows should still be checked manually when a change affects scene behavior or UI.
