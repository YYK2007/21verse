# Public Asset Manifest

This handoff converts the Unity asset audit into a public-release keep/exclude/replacement map.

Authoritative generated file:

- `docs/inventory/unity-public-asset-manifest.csv`

NOTICE/attribution gaps for the same folders are tracked in `docs/unity-attribution-gap-report.md` and `docs/inventory/unity-attribution-gap-report.csv`.

Refresh it after any Unity asset change:

```powershell
.\tools\export-public-asset-manifest.ps1
.\tools\export-unity-attribution-gap-report.ps1
```

## Treatment Values

- `retain_candidate_reviewed`: Keep candidate for the public repo after folder-level review identifies it as project-owned or otherwise covered by the current repository scope.
- `exclude_until_import_or_rights_confirmed`: Do not publish this folder in the open-source repo unless redistribution rights are confirmed or the dependency is reconstructed through documented package/import steps.
- `replace_before_public_release`: Replace with original or verified redistributable content before the repo is made public.
- `exclude_until_rights_confirmed`: Keep private until written rights evidence exists.
- `needs_manual_review`: No final public decision has been made.

The manifest does not grant third-party redistribution rights by itself. Issue #2 can stay closed while every high-risk folder has a non-pending disposition, removed folders remain out of the repo, retained folders have NOTICE scope coverage, Unity validation passes, and the release audit no longer reports the Unity asset gate as a blocker.
