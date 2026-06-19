# Unity Validation

Status as of 2026-06-19: batchmode project open/import passed; interactive scene smoke test still pending.

## Environment

- Unity editor: `2022.3.25f1`
- Project: `unity/21verse-vr-game-hub`
- Project version file: `ProjectSettings/ProjectVersion.txt`
- Validation command: Unity batchmode project open with `-batchmode -nographics -quit`

## Result

Unity opened the curated project, rebuilt the local `Library` cache, imported assets, and exited successfully with return code `0`.

The raw Unity batchmode log was not committed because it contains local machine and Unity licensing metadata. The local log also reported shader fallback warnings for several URP and Shader Graph materials; these should be reviewed during the interactive scene smoke test, but they did not prevent the batchmode import from completing.

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
