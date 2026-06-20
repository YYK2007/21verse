# GitHub Release State Snapshot

This generated snapshot records the current private GitHub repository state that supports the future public-release handoff.

Authoritative generated file:

- `docs/inventory/github-release-state.csv`

Refresh it with:

```powershell
.\tools\export-github-release-state.ps1
```

The snapshot records local/remote head alignment, repository visibility, default branch, repository features, topics, the public-release milestone, required blocker issues, and the latest `Repo Hygiene` Actions run for `HEAD`.

This is evidence only. `tools/test-github-release-state.ps1` remains the pass/fail verifier.
