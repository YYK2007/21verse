# Unity Smoke Test Checklist

This checklist tracks the remaining interactive Unity validation work for GitHub issue #3.

Source evidence:

- `docs/unity-validation.md`
- `tools/run-unity-scene-validation.ps1`
- `docs/inventory/unity-smoke-test-status.csv`

## Current State

Unity `2022.3.25f1` batchmode project open/import and scene-open validation passed for the curated project. Interactive Unity/VR smoke testing is still pending and must happen before the repository is made public.

## Completion Checklist

| Step | Status | Evidence required |
| --- | --- | --- |
| Open project interactively | `pending` | `unity/21verse-vr-game-hub` opens in Unity Hub with Unity `2022.3.25f1` after clone. |
| Smoke-test README scenes | `pending` | `MainMenu`, `WordLevel01`, `AdjectiveLevel01`, `IdentifyingColors`, `NumberLevelUI01`, `NumberInequalitiesLevel`, and `Cashier` are loaded and checked interactively. |
| Review XR setup and interactions | `pending` | XR origin/controllers, navigation, scene transitions, and core learning interactions behave acceptably or are documented. |
| Review rendering warnings | `pending` | Shader fallback/material warnings from batchmode import are checked visually or documented. |
| Refresh validation evidence | `pending` | `docs/unity-validation.md`, this checklist, issue #3, and `docs/inventory/release-audit.md` reflect the final smoke-test result. |

Issue #3 can close only when every row in `docs/inventory/unity-smoke-test-status.csv` is `complete` and the release audit no longer treats interactive Unity validation as pending.
