# Public Release File Plan

This dry-run plan maps tracked repository files to their current public-release treatment.

Authoritative generated file:

- `docs/inventory/public-release-file-plan.csv`

Refresh it with:

```powershell
.\tools\export-public-release-file-plan.ps1
```

The planner does not copy, delete, publish, or change repository visibility. It reads `git ls-files` and `docs/inventory/unity-public-asset-manifest.csv`, then marks files as:

- `include`: tracked source, docs, config, or non-Unity-asset files that are not currently flagged by the asset manifest.
- `include_pending_final_review`: tracked Unity asset files under retained project folders. These remain visible for final review before future release changes.
- `exclude_until_resolved`: tracked Unity files under asset folders that require rights confirmation, replacement, external import, or removal for public release.
- `exclude_generated`: generated outputs that should not be part of a public source tree.

This plan is a release-review aid, not a substitute for owner approval. Do not add excluded or unresolved files to future public release changes.
