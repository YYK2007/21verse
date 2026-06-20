# Release Evidence Manifest

This manifest is the reviewer-facing map from the original open-source preparation request to the evidence currently staged in this private repository.

The repository must stay private until every required item below is either `complete` or deliberately excluded with a documented public-release rationale.

Machine-readable status is tracked in `docs/inventory/release-requirements-status.csv`.

## Evidence Map

| Requirement | Current status | Authoritative evidence | Completion condition |
| --- | --- | --- | --- |
| Review local 21Verse files across the computer | complete | `docs/source-inventory.md`, `docs/design-and-nas-inventory.md`, `docs/inventory/unity-projects.csv`, `docs/inventory/local-design-summary.csv` | Local Unity, design, and document sources are inventoried and the curated repo source is documented. |
| Review attached NAS `Youssef Storage` | blocked | `docs/design-and-nas-inventory.md`, `docs/nas-review-checklist.md`, `docs/inventory/nas-access-log.csv`, `docs/inventory/nas-review-status.csv` | NAS share is mounted/authenticated, candidate files are inventoried and reviewed, and every NAS status row is `complete`. |
| Review Unity projects and select the public repo candidate | complete | `docs/source-inventory.md`, `docs/game-design-summary.md`, `docs/unity-validation.md`, `docs/inventory/unity-projects.csv` | Curated Unity project is included and batchmode scene validation passes. |
| Complete interactive Unity/VR smoke testing | blocked | `docs/unity-validation.md`, `docs/unity-smoke-test-checklist.md`, `docs/inventory/unity-smoke-test-status.csv`, `docs/inventory/unity-pre-smoke-status.csv` | Project opens interactively, README scenes are smoke-tested, XR interactions/rendering are checked, and every Unity smoke-test status row is `complete`. |
| Resolve Unity third-party asset rights | blocked | `docs/third-party-assets.md`, `docs/asset-removal-plan.md`, `docs/asset-disposition-tracker.md`, `docs/unity-external-imports.md`, `docs/inventory/unity-asset-audit.csv`, `docs/inventory/unity-risky-asset-references.csv`, `docs/inventory/unity-asset-replacement-worklist.csv`, `docs/inventory/unity-asset-disposition.csv`, `docs/inventory/unity-external-imports.csv` | Every asset disposition row has a non-`pending` decision, retained assets have documented rights, and Unity validation still passes. |
| Review Google Drive docs, decks, sheets, and Slides | complete for inventory; export decisions pending by design | `docs/google-drive-inventory.md`, `docs/google-drive-release-plan.md`, `docs/inventory/google-drive-21verse.csv`, `docs/inventory/google-drive-release-plan.csv` | Only redacted public-safe derivatives are exported; private rows remain excluded. |
| Stage open-source governance and contributor docs | complete | `README.md`, `LICENSE`, `NOTICE.md`, `CONTRIBUTING.md`, `SECURITY.md`, `CODE_OF_CONDUCT.md`, `SUPPORT.md`, `CHANGELOG.md` | Public-facing governance files are present and reviewed before visibility changes. |
| Stage GitHub repo configuration privately | complete | `docs/github-private-repo.md`, `docs/github-metadata.md`, `docs/github-tracker.md`, `.github/` | Private repo exists, metadata is documented, issue templates and hygiene workflow are staged. |
| Verify GitHub branch protection before public release | blocked | `docs/github-branch-protection.md`, `docs/inventory/github-branch-protection-status.csv`, `tools/test-github-branch-protection.ps1` | A GitHub admin verifies `main` branch protection, required pull requests, required `Repo Hygiene` check, disabled force pushes, and disabled branch deletion. |
| Keep repository private until release approval | complete and ongoing | `docs/github-private-repo.md`, `docs/public-release-runbook.md`, `docs/inventory/release-audit.md` | GitHub visibility remains private until the release audit has no blockers and the milestone is cleared. |

## Final Evidence Gate

Before changing repository visibility to public:

1. Resolve GitHub issues #1, #2, #3, and #5.
2. Run the inventory and validation commands in `docs/public-release-runbook.md`.
3. Run `tools/test-repo-hygiene.ps1`.
4. Run `tools/run-release-audit.ps1`.
5. Confirm `docs/inventory/release-audit.md` reports no blockers.
6. Confirm GitHub Actions are green on `main`.

If any evidence source above contradicts the release audit, treat the repo as not ready and update the audit or source document before publication.
