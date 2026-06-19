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
