# Release Blocker Action Plan

This generated handoff turns the current blocked release requirements into a concise action list.

Authoritative generated file:

- `docs/inventory/release-blocker-action-plan.csv`

Refresh it with:

```powershell
.\tools\export-release-blocker-action-plan.ps1
```

The plan is intentionally narrow: it includes only rows from `docs/inventory/release-requirements-status.csv` where `status` is `blocked`. It does not close blockers by itself. If blockers appear in a future audit, resolve them before publishing additional release changes.
