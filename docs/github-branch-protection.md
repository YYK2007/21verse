# GitHub Branch Protection

This document records the verified `main` branch protection state for the public open-source repository.

Current verification result:

- The repo-prep session can verify repository metadata, labels, issues, milestone, and Actions runs.
- Branch protection was applied after publication.
- `tools/test-github-branch-protection.ps1` verified the GitHub branch protection endpoint for `main` returned `200 OK`.
- `docs/inventory/github-branch-protection-status.csv` records all required branch protection rows as `complete`.

Verified state:

- `main` is protected.
- Pull requests are required before merging.
- The `Repository hygiene` check from the `Repo Hygiene` workflow is required before merge.
- Conversations are resolved before merge.
- Force pushes are disabled.
- Deletions are disabled.
- Admin bypass is reviewed intentionally.

Final admin-side verification is recorded in `docs/inventory/github-branch-protection-status.csv`.

To refresh the local handoff evidence, run:

```powershell
.\tools\test-github-branch-protection.ps1
```

The script probes `GET /repos/YYK2007/21verse/branches/main/protection` and rewrites `docs/inventory/github-branch-protection-status.csv`. If the current credential or repository plan cannot inspect protection in the future, the CSV will record that explicitly instead of silently claiming protection is configured.

To reapply the desired settings from a GitHub admin session:

```powershell
.\tools\set-github-branch-protection.ps1
.\tools\set-github-branch-protection.ps1 -Apply
.\tools\test-github-branch-protection.ps1
```

The first command is a dry run that prints the JSON payload. The `-Apply` command sends `PUT /repos/YYK2007/21verse/branches/main/protection` and requires both an admin-capable GitHub credential and branch protection availability for the current repository visibility/plan.
