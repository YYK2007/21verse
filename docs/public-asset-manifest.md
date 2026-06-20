# Public Asset Manifest

This handoff converts the Unity asset audit into a public-release keep/exclude/replacement map.

Authoritative generated file:

- `docs/inventory/unity-public-asset-manifest.csv`

Refresh it after any Unity asset change:

```powershell
.\tools\export-public-asset-manifest.ps1
```

## Treatment Values

- `retain_candidate_reviewed`: Keep candidate for the public repo if final manual ownership review still confirms it is project-owned or redistributable.
- `exclude_until_import_or_rights_confirmed`: Do not publish this folder in the open-source repo unless redistribution rights are confirmed or the dependency is reconstructed through documented package/import steps.
- `replace_before_public_release`: Replace with original or verified redistributable content before the repo is made public.
- `exclude_until_rights_confirmed`: Keep private until written rights evidence exists.
- `needs_manual_review`: No final public decision has been made.

The manifest does not clear issue #2 by itself. Issue #2 can close only after every pending folder has a non-pending disposition, retained third-party assets have rights and attribution evidence, replacement/import work has been validated in Unity, and the release audit no longer reports the Unity asset gate as a blocker.
