# Unity Validation

Status as of 2026-06-20: batchmode scene-open validation passed after the `Cashier` build-settings update and after removing uncleared bundled third-party/downloaded asset folders, and the listed project scenes open in batchmode with zero missing script references. Interactive gameplay/VR smoke testing is deferred by current project scope.

## Environment

- Unity editor: `2022.3.25f1`
- Project: `unity/21verse-vr-game-hub`
- Project version file: `ProjectSettings/ProjectVersion.txt`
- Validation command: Unity batchmode project open with `-batchmode -nographics -quit`
- Scene validation command: `tools/run-unity-scene-validation.ps1`

## Result

Unity opened the curated project, rebuilt the local `Library` cache, imported assets, and exited successfully with return code `0`.

The raw Unity batchmode log was not committed because it contains local machine and Unity licensing metadata. Earlier validation logs reported shader fallback warnings for several URP and Shader Graph materials; after the asset removal pass, the validation target is structural scene-open health rather than final gameplay visuals.

Automated pre-smoke structural checks are tracked in `docs/inventory/unity-pre-smoke-status.csv` and regenerated with `tools/export-unity-pre-smoke-status.ps1`. They confirm scene presence, build-settings inclusion, and XR scene markers before interactive testing.

## Scene Validation

`SceneValidation.ValidateConfiguredScenes` opened each listed scene in Unity batchmode and checked for missing script components.

These scene files are treated as 21Verse-developed learning/gameplay scene compositions for release-prep purposes. The validation below proves the scene files open structurally; it does not clear the redistribution rights for every visual, package, sample, template, or downloaded asset referenced by those scenes.

| Scene | Result | Root objects | GameObjects |
| --- | --- | ---: | ---: |
| `Assets/Scenes/MainMenu.unity` | Opened successfully; 0 missing scripts | 11 | 30 |
| `Assets/Scenes/WordLevel01.unity` | Opened successfully; 0 missing scripts | 9 | 30 |
| `Assets/Scenes/AdjectiveLevel01.unity` | Opened successfully; 0 missing scripts | 9 | 26 |
| `Assets/Scenes/IdentifyingColors.unity` | Opened successfully; 0 missing scripts | 9 | 21 |
| `Assets/Scenes/NumberLevelUI01.unity` | Opened successfully; 0 missing scripts | 9 | 37 |
| `Assets/Scenes/NumberInequalitiesLevel.unity` | Opened successfully; 0 missing scripts | 9 | 32 |
| `Assets/Scenes/Cashier.unity` | Opened successfully; 0 missing scripts | 10 | 32 |

A stale missing script component was removed from `Canvas/OptionsRow/OptionButton (2)` in `Assets/Scenes/NumberInequalitiesLevel.unity`; the rerun passed after that cleanup. The latest rerun also passed after removing uncleared bundled asset folders, with lower GameObject counts because third-party visual/sample/template content is no longer bundled.

## Remaining Validation

Interactive VR smoke testing is deferred by the current project scope. For a future gameplay release, open the project interactively in Unity `2022.3.25f1` and smoke-test these project scenes:

- `Assets/Scenes/MainMenu.unity`
- `Assets/Scenes/WordLevel01.unity`
- `Assets/Scenes/AdjectiveLevel01.unity`
- `Assets/Scenes/IdentifyingColors.unity`
- `Assets/Scenes/NumberLevelUI01.unity`
- `Assets/Scenes/NumberInequalitiesLevel.unity`
- `Assets/Scenes/Cashier.unity`

Optional future interactive smoke-test work is tracked in GitHub issue #3.
Detailed interactive smoke-test status is tracked in `docs/unity-smoke-test-checklist.md` and `docs/inventory/unity-smoke-test-status.csv`.
Pre-smoke structural status is tracked in `docs/inventory/unity-pre-smoke-status.csv`.
