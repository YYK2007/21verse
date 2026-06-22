# GitHub Branch Protection Handoff

This handoff records the desired `main` branch protection state for the public open-source repository.

Current verification result:

- The repo-prep session can verify repository metadata, labels, issues, milestone, and Actions runs.
- The GitHub branch protection endpoint for `main` returned `403 Forbidden`.
- Applying the desired branch protection returned GitHub's plan/visibility message: `Upgrade to GitHub Pro or make this repository public to enable this feature.`
- Branch protection was blocked while the repository was private because GitHub required either GitHub Pro or public visibility for the selected settings.

Desired state:

- `main` is protected.
- Pull requests are required before merging.
- The `Repository hygiene` check from the `Repo Hygiene` workflow is required before merge.
- Conversations are resolved before merge.
- Force pushes are disabled.
- Deletions are disabled.
- Admin bypass is reviewed intentionally.

Record final admin-side verification in `docs/inventory/github-branch-protection-status.csv`.

To refresh the local handoff evidence, run:

```powershell
.\tools\test-github-branch-protection.ps1
```

The script probes `GET /repos/YYK2007/21verse/branches/main/protection` and rewrites `docs/inventory/github-branch-protection-status.csv`. If the current credential or repository plan still cannot inspect protection, the CSV remains an explicit verification handoff instead of silently claiming protection is configured.

To apply the desired settings from a GitHub admin session:

```powershell
.\tools\set-github-branch-protection.ps1
.\tools\set-github-branch-protection.ps1 -Apply
.\tools\test-github-branch-protection.ps1
```

The first command is a dry run that prints the JSON payload. The `-Apply` command sends `PUT /repos/YYK2007/21verse/branches/main/protection` and requires both an admin-capable GitHub credential and branch protection availability for the current repository visibility/plan.
