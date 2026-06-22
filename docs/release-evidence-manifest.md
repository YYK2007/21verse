# Release Evidence Manifest

This manifest is the reviewer-facing map from the original open-source preparation request to the evidence for the public repository.

The repository was approved for publication after every required item below was either `complete`, deliberately excluded by scope, or explicitly deferred by a documented platform/user-scope rationale.

Machine-readable status is tracked in `docs/inventory/release-requirements-status.csv`.
Current blocked-requirement owner actions are tracked in `docs/inventory/release-blocker-action-plan.csv`.

## Evidence Map

| Requirement | Current status | Authoritative evidence | Completion condition |
| --- | --- | --- | --- |
| Review local 21Verse files across the computer | complete | `docs/source-inventory.md`, `docs/design-and-nas-inventory.md`, `docs/inventory/unity-projects.csv`, `docs/inventory/local-design-summary.csv`, `docs/inventory/local-drive-review-status.csv` | Local Unity, design, and document sources are inventoried and the curated repo source is documented. |
| Review attached NAS `Youssef Storage` | excluded by user request | `docs/design-and-nas-inventory.md`, `docs/nas-review-runbook.md`, `docs/nas-review-checklist.md`, `docs/inventory/nas-access-log.csv`, `docs/inventory/nas-review-status.csv`, `tools/test-nas-access.ps1` | Excluded from the current release-prep scope by user request on 2026-06-20; do not include NAS files unless the user reopens this scope. |
| Review Unity projects and select the public repo candidate | complete | `docs/source-inventory.md`, `docs/game-design-summary.md`, `docs/unity-validation.md`, `docs/inventory/unity-projects.csv` | Curated Unity project is included and batchmode scene validation passes. |
| Complete interactive Unity/VR smoke testing | deferred optional | `docs/unity-validation.md`, `docs/unity-smoke-test-checklist.md`, `docs/unity-interactive-smoke-plan.md`, `docs/inventory/unity-smoke-test-status.csv`, `docs/inventory/unity-pre-smoke-status.csv`, `docs/inventory/unity-interactive-smoke-plan.csv`, `tools/export-unity-pre-smoke-status.ps1`, `tools/export-unity-interactive-smoke-plan.ps1`, `tools/run-unity-scene-validation.ps1` | Deferred by user request on 2026-06-20; keep automated validation evidence, but interactive VR smoke testing is optional before a VR gameplay release. |
| Resolve Unity third-party asset rights | complete | `docs/third-party-assets.md`, `docs/asset-removal-plan.md`, `docs/asset-disposition-tracker.md`, `docs/unity-external-imports.md`, `docs/public-asset-manifest.md`, `docs/unity-attribution-gap-report.md`, `docs/public-release-file-plan.md`, `docs/inventory/unity-asset-audit.csv`, `docs/inventory/unity-risky-asset-references.csv`, `docs/inventory/unity-asset-replacement-worklist.csv`, `docs/inventory/unity-public-asset-manifest.csv`, `docs/inventory/unity-attribution-gap-report.csv`, `docs/inventory/unity-third-party-removal-status.csv`, `docs/inventory/public-release-file-plan.csv`, `docs/inventory/unity-asset-disposition.csv`, `docs/inventory/unity-external-imports.csv`, `tools/export-unity-asset-replacement-worklist.ps1`, `tools/export-public-asset-manifest.ps1`, `tools/export-unity-attribution-gap-report.ps1`, `tools/export-unity-third-party-removal-status.ps1`, `tools/export-public-release-file-plan.ps1` | Uncleared downloaded/third-party Unity asset folders are removed from the repo, every asset disposition row has a non-`pending` decision, retained project folders have NOTICE scope coverage, and Unity validation still passes. |
| Review Google Drive docs, decks, sheets, and Slides | complete for inventory; export decisions pending by design | `docs/google-drive-inventory.md`, `docs/google-drive-release-plan.md`, `docs/google-drive-public-manifest.md`, `docs/inventory/google-drive-21verse.csv`, `docs/inventory/google-drive-release-plan.csv`, `docs/inventory/google-drive-public-manifest.csv`, `tools/export-google-drive-release-plan.ps1`, `tools/export-google-drive-public-manifest.ps1` | Only redacted public-safe derivatives are exported; private rows remain excluded. |
| Stage open-source governance and contributor docs | complete | `README.md`, `LICENSE`, `NOTICE.md`, `CONTRIBUTING.md`, `SECURITY.md`, `CODE_OF_CONDUCT.md`, `SUPPORT.md`, `CHANGELOG.md` | Public-facing governance files are present and reviewed before visibility changes. |
| Stage GitHub repo configuration for release | complete | `docs/github-repo-handoff.md`, `docs/github-metadata.md`, `docs/github-tracker.md`, `docs/github-release-state.md`, `docs/inventory/github-release-state.csv`, `.github/` | Repository metadata is documented, issue templates and hygiene workflow are staged, and release approval has been given. |
| Verify GitHub branch protection before public release | deferred platform limit | `docs/github-branch-protection.md`, `docs/inventory/github-branch-protection-status.csv`, `docs/public-release-runbook.md`, `tools/test-github-branch-protection.ps1`, `tools/set-github-branch-protection.ps1` | GitHub returned `403` before publication because branch protection for the private repo required GitHub Pro or public visibility. Verify branch protection after publication. |
| Publish repository after release approval | complete | `docs/github-repo-handoff.md`, `docs/public-release-runbook.md`, `docs/github-release-state.md`, `docs/inventory/github-release-state.csv`, `docs/inventory/release-audit.md` | GitHub visibility may be public after release approval, with branch protection verified afterward. |

## Final Evidence Gate

Publication gate:

1. Confirm GitHub issues #2 and #5 are closed or explicitly deferred by the current release scope. Issues #1 and #3 are no longer release blockers under the 2026-06-20 scope update unless the user reopens NAS or interactive VR smoke testing as required work.
2. Run the inventory and validation commands in `docs/public-release-runbook.md`.
3. Regenerate `docs/inventory/release-blocker-action-plan.csv` with `tools/export-release-blocker-action-plan.ps1`.
4. Run `tools/test-repo-hygiene.ps1`.
5. Run `tools/run-release-audit.ps1`.
6. Confirm `docs/inventory/release-audit.md` reports no content blockers.
7. Confirm GitHub Actions are green on `main`.
8. Apply and verify branch protection for the public repository.

If any evidence source above contradicts the release audit, treat the repo as not ready and update the audit or source document before publication.
