# GitHub Release State Snapshot

This generated snapshot records the current GitHub repository state that supports the public-release handoff.

Authoritative generated file:

- `docs/inventory/github-release-state.csv`

Refresh it with:

```powershell
.\tools\export-github-release-state.ps1
```

The snapshot records repository visibility, default branch, repository features, topics, the public-release milestone, scoped/deferred release tracker issues, and the latest completed `Repo Hygiene` Actions run.

This is evidence only. `tools/test-github-release-state.ps1` remains the pass/fail verifier.
