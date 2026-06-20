# Unity Interactive Smoke Plan

This plan turns the automated pre-smoke scene inventory into a scene-by-scene manual smoke-test checklist for GitHub issue #3.

Authoritative generated file:

- `docs/inventory/unity-interactive-smoke-plan.csv`

Refresh it with:

```powershell
.\tools\export-unity-pre-smoke-status.ps1
.\tools\export-unity-interactive-smoke-plan.ps1
```

## Scope

The plan covers the seven README scenes:

- `MainMenu`
- `WordLevel01`
- `AdjectiveLevel01`
- `IdentifyingColors`
- `NumberLevelUI01`
- `NumberInequalitiesLevel`
- `Cashier`

Each row carries forward the automated structural status, known risky asset reference count, risky asset folders, required manual checks, and the pass condition. It does not replace the actual interactive Unity/VR smoke test; it makes that manual pass reproducible and reviewable.
