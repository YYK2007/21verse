# GitHub Branch Protection Handoff

This handoff records the desired `main` branch protection state for the private staging repository.

Current verification result:

- The repo-prep session can verify repository metadata, labels, issues, milestone, and Actions runs.
- The GitHub branch protection endpoint for `main` returned `403 Forbidden` to the available credential, so branch protection could not be inspected or changed from this session.

Desired state before public release:

- `main` is protected.
- Pull requests are required before merging.
- The `Repo Hygiene` check is required before merge.
- Conversations are resolved before merge.
- Force pushes are disabled.
- Deletions are disabled.
- Admin bypass is reviewed intentionally.

Record final admin-side verification in `docs/inventory/github-branch-protection-status.csv`.

To refresh the local handoff evidence, run:

```powershell
.\tools\test-github-branch-protection.ps1
```

The script probes `GET /repos/YYK2007/21verse_opensource/branches/main/protection` and rewrites `docs/inventory/github-branch-protection-status.csv`. If the current credential still lacks admin access, the CSV remains an explicit admin-verification handoff instead of silently claiming protection is configured.
