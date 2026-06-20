# GitHub Tracker

The private GitHub tracker is configured for public-release readiness work.

## Milestone

- [Public release readiness](https://github.com/YYK2007/21verse_opensource/milestone/1)
- State: open
- Purpose: resolve all blockers before changing the repository from private to public.

## Open Release Issues

| Issue | Purpose | Required before public release |
| --- | --- | --- |
| [#1 Review 21Verse files on Youssef Storage NAS](https://github.com/YYK2007/21verse_opensource/issues/1) | Complete NAS inventory/review. | Yes |
| [#2 Confirm third-party Unity asset redistribution rights](https://github.com/YYK2007/21verse_opensource/issues/2) | Resolve asset rights, replacement, or removal decisions. | Yes |
| [#3 Open curated Unity project and smoke test main scenes](https://github.com/YYK2007/21verse_opensource/issues/3) | Complete interactive Unity/VR smoke testing. | Yes |

## Issue Evidence Sources

| Issue | Primary evidence in repo | Current unresolved evidence |
| --- | --- | --- |
| #1 | `docs/design-and-nas-inventory.md`, `docs/nas-review-runbook.md`, `docs/nas-review-checklist.md`, `docs/inventory/nas-review-status.csv` | NAS share access is still blocked; five NAS review status rows are not complete. |
| #2 | `docs/third-party-assets.md`, `docs/asset-removal-plan.md`, `docs/asset-disposition-tracker.md`, `docs/inventory/unity-asset-disposition.csv` | Nine Unity asset disposition rows are still `pending`. |
| #3 | `docs/unity-validation.md`, `docs/unity-smoke-test-checklist.md`, `docs/inventory/unity-smoke-test-status.csv` | Batchmode validation passed; five interactive smoke-test status rows are not complete. |

## Release Labels

| Label | Meaning |
| --- | --- |
| `blocker` | Must be resolved before public release. |
| `open-source-readiness` | Work required for future public open-source release. |
| `licensing` | Licensing, attribution, or redistribution rights review. |
| `nas` | Youssef Storage / WDMyCloudEX4100 inventory and review. |
| `unity` | Unity project, scenes, packages, or assets. |
| `validation` | Validation, smoke testing, or release audit work. |

The repository should not be made public while this milestone has open blocker issues.

`tools/test-github-release-state.ps1` verifies these release labels, the milestone, required open issues, private visibility, metadata, and the latest `Repo Hygiene` result from a Windows session with GitHub credentials.
