# Unity Smoke Test Checklist

This checklist tracks the remaining interactive Unity validation work for GitHub issue #3.

Source evidence:

- `docs/unity-validation.md`
- `tools/run-unity-scene-validation.ps1`
- `tools/export-unity-pre-smoke-status.ps1`
- `tools/export-unity-interactive-smoke-plan.ps1`
- `docs/inventory/unity-smoke-test-status.csv`
- `docs/inventory/unity-pre-smoke-status.csv`
- `docs/inventory/unity-interactive-smoke-plan.csv`

## Current State

Unity `2022.3.25f1` batchmode project open/import and scene-open validation passed for the curated project. Interactive Unity/VR smoke testing is still pending, but it is deferred from the current release-prep scope and should be reopened before a VR gameplay release.

Automated pre-smoke structural checks are tracked in `docs/inventory/unity-pre-smoke-status.csv`. These checks confirm scene files, enabled build-settings entries, and XR scene markers, but they do not replace interactive Unity/VR smoke testing when gameplay validation returns to scope.

The scene-by-scene manual smoke plan is tracked in `docs/inventory/unity-interactive-smoke-plan.csv` and summarized in `docs/unity-interactive-smoke-plan.md`.

## Completion Checklist

| Step | Status | Evidence required |
| --- | --- | --- |
| Open project interactively | `pending` | `unity/21verse-vr-game-hub` opens in Unity Hub with Unity `2022.3.25f1` after clone. |
| Smoke-test README scenes | `pending` | `MainMenu`, `WordLevel01`, `AdjectiveLevel01`, `IdentifyingColors`, `NumberLevelUI01`, `NumberInequalitiesLevel`, and `Cashier` are loaded and checked interactively. |
| Review XR setup and interactions | `pending` | XR origin/controllers, navigation, scene transitions, and core learning interactions behave acceptably or are documented. |
| Review rendering warnings | `pending` | Shader fallback/material warnings from batchmode import are checked visually or documented. |
| Refresh validation evidence | `pending` | `docs/unity-validation.md`, this checklist, issue #3, and `docs/inventory/release-audit.md` reflect the final smoke-test result. |

Issue #3 is closed as deferred for the current scope. Reopen it when interactive Unity/VR smoke testing becomes required, then complete every row in `docs/inventory/unity-smoke-test-status.csv` and refresh the release audit.
