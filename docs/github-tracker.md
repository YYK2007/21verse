# GitHub Tracker

The GitHub tracker is configured for public-release readiness and follow-up work.

## Milestone

- [Public release readiness](https://github.com/YYK2007/21verse_opensource/milestone/1)
- State: open
- Purpose: resolve all blockers before changing the repository from private to public.

## Release Issues

| Issue | Purpose | Current release status |
| --- | --- | --- |
| [#1 Review 21Verse files on Youssef Storage NAS](https://github.com/YYK2007/21verse_opensource/issues/1) | Complete NAS inventory/review. | Closed after user excluded NAS from the current scope. |
| [#2 Confirm third-party Unity asset redistribution rights](https://github.com/YYK2007/21verse_opensource/issues/2) | Resolve asset rights, replacement, or removal decisions. | Closed after uncleared downloaded/third-party Unity asset folders were removed from the repo. |
| [#3 Open curated Unity project and smoke test main scenes](https://github.com/YYK2007/21verse_opensource/issues/3) | Complete interactive Unity/VR smoke testing. | Closed after user deferred interactive VR smoke from the current scope. |
| [#5 Verify GitHub branch protection before public release](https://github.com/YYK2007/21verse_opensource/issues/5) | Verify or configure `main` branch protection from a GitHub admin session. | Platform-deferred while private because GitHub returned a Pro/public-visibility requirement for branch protection. |

## Issue Evidence Sources

| Issue | Primary evidence in repo | Current unresolved evidence |
| --- | --- | --- |
| #1 | `docs/design-and-nas-inventory.md`, `docs/nas-review-runbook.md`, `docs/nas-review-checklist.md`, `docs/inventory/nas-review-status.csv` | NAS share access is still blocked; five NAS review status rows are not complete. |
| #2 | `docs/third-party-assets.md`, `docs/asset-removal-plan.md`, `docs/asset-disposition-tracker.md`, `docs/public-asset-manifest.md`, `docs/public-release-file-plan.md`, `docs/inventory/unity-asset-disposition.csv`, `docs/inventory/unity-public-asset-manifest.csv`, `docs/inventory/public-release-file-plan.csv` | Uncleared downloaded/third-party Unity folders are removed; disposition rows are non-pending; public asset/file manifests no longer list exclusion blockers. |
| #3 | `docs/unity-validation.md`, `docs/unity-smoke-test-checklist.md`, `docs/inventory/unity-smoke-test-status.csv` | Batchmode validation passed; five interactive smoke-test status rows are not complete. |
| #5 | `docs/github-branch-protection.md`, `docs/inventory/github-branch-protection-status.csv`, `tools/test-github-branch-protection.ps1`, `tools/set-github-branch-protection.ps1` | GitHub returned a Pro/public-visibility requirement for branch protection while the repo remains private; `tools/set-github-branch-protection.ps1` provides the ready-to-apply payload after GitHub Pro or approved publication. |

## Issue Label Expectations

| Issue | Required labels |
| --- | --- |
| #1 | `nas`, `open-source-readiness` |
| #2 | `licensing`, `open-source-readiness` |
| #3 | `open-source-readiness`, `unity`, `validation` |
| #5 | `open-source-readiness`, `validation` |

## Issue Body Evidence Expectations

| Issue | Required evidence references |
| --- | --- |
| #1 | `docs/design-and-nas-inventory.md`, `docs/nas-review-checklist.md`, `docs/inventory/nas-access-log.csv`, `docs/inventory/nas-review-status.csv`, `tools/test-nas-access.ps1` |
| #2 | `docs/third-party-assets.md`, `docs/asset-disposition-tracker.md`, `docs/public-asset-manifest.md`, `docs/public-release-file-plan.md`, `docs/inventory/unity-asset-disposition.csv`, `docs/inventory/unity-public-asset-manifest.csv`, `docs/inventory/public-release-file-plan.csv` |
| #3 | `docs/unity-validation.md`, `docs/unity-smoke-test-checklist.md`, `docs/inventory/unity-smoke-test-status.csv` |
| #5 | `docs/github-branch-protection.md`, `docs/inventory/github-branch-protection-status.csv`, `tools/test-github-branch-protection.ps1`, `tools/set-github-branch-protection.ps1` |

## Release Labels

| Label | Meaning |
| --- | --- |
| `blocker` | Must be resolved before public release. |
| `open-source-readiness` | Work required for future public open-source release. |
| `licensing` | Licensing, attribution, or redistribution rights review. |
| `nas` | Youssef Storage / WDMyCloudEX4100 inventory and review. |
| `unity` | Unity project, scenes, packages, or assets. |
| `validation` | Validation, smoke testing, or release audit work. |

The repository should not be made public while this milestone has open blocker issues or while the release audit reports content blockers. Branch protection remains an immediate post-publication or GitHub Pro action because the repo must stay private for now.

`tools/test-github-release-state.ps1` verifies these release labels, issue label expectations, issue body evidence references, the milestone, required open issues, private visibility, metadata, and the latest `Repo Hygiene` result from a Windows session with GitHub credentials.
