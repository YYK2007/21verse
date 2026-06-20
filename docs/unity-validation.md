# Unity Validation

Status as of 2026-06-20: batchmode scene-open validation passed after the `Cashier` build-settings update, and the listed project scenes open in batchmode with zero missing script references. Interactive gameplay/VR smoke testing is still pending.

## Environment

- Unity editor: `2022.3.25f1`
- Project: `unity/21verse-vr-game-hub`
- Project version file: `ProjectSettings/ProjectVersion.txt`
- Validation command: Unity batchmode project open with `-batchmode -nographics -quit`
- Scene validation command: `tools/run-unity-scene-validation.ps1`

## Result

Unity opened the curated project, rebuilt the local `Library` cache, imported assets, and exited successfully with return code `0`.

The raw Unity batchmode log was not committed because it contains local machine and Unity licensing metadata. The local log also reported shader fallback warnings for several URP and Shader Graph materials; these should be reviewed during the interactive scene smoke test, but they did not prevent the batchmode import from completing.

Automated pre-smoke structural checks are tracked in `docs/inventory/unity-pre-smoke-status.csv` and regenerated with `tools/export-unity-pre-smoke-status.ps1`. They confirm scene presence, build-settings inclusion, and XR scene markers before interactive testing.

## Scene Validation

`SceneValidation.ValidateConfiguredScenes` opened each listed scene in Unity batchmode and checked for missing script components.

| Scene | Result | Root objects | GameObjects |
| --- | --- | ---: | ---: |
| `Assets/Scenes/MainMenu.unity` | Opened successfully; 0 missing scripts | 11 | 377 |
| `Assets/Scenes/WordLevel01.unity` | Opened successfully; 0 missing scripts | 9 | 377 |
| `Assets/Scenes/AdjectiveLevel01.unity` | Opened successfully; 0 missing scripts | 9 | 373 |
| `Assets/Scenes/IdentifyingColors.unity` | Opened successfully; 0 missing scripts | 9 | 368 |
| `Assets/Scenes/NumberLevelUI01.unity` | Opened successfully; 0 missing scripts | 9 | 384 |
| `Assets/Scenes/NumberInequalitiesLevel.unity` | Opened successfully; 0 missing scripts | 9 | 379 |
| `Assets/Scenes/Cashier.unity` | Opened successfully; 0 missing scripts | 10 | 130 |

A stale missing script component was removed from `Canvas/OptionsRow/OptionButton (2)` in `Assets/Scenes/NumberInequalitiesLevel.unity`; the rerun passed after that cleanup.

## Remaining Validation

Open the project interactively in Unity `2022.3.25f1` and smoke-test these project scenes:

- `Assets/Scenes/MainMenu.unity`
- `Assets/Scenes/WordLevel01.unity`
- `Assets/Scenes/AdjectiveLevel01.unity`
- `Assets/Scenes/IdentifyingColors.unity`
- `Assets/Scenes/NumberLevelUI01.unity`
- `Assets/Scenes/NumberInequalitiesLevel.unity`
- `Assets/Scenes/Cashier.unity`

Track remaining work in GitHub issue #3.
Detailed interactive smoke-test status is tracked in `docs/unity-smoke-test-checklist.md` and `docs/inventory/unity-smoke-test-status.csv`.
Pre-smoke structural status is tracked in `docs/inventory/unity-pre-smoke-status.csv`.
