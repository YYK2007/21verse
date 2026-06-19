---
name: Asset release review
about: Track a Unity asset folder that needs public-release rights or replacement decisions
title: "Asset review: "
labels: release, assets
assignees: ""
---

## Asset Folder

`Assets/...`

## Evidence

- Audit row: `docs/inventory/unity-asset-audit.csv`
- Reference row: `docs/inventory/unity-risky-asset-references.csv`
- Notes:

## Release Decision

- [ ] Confirmed redistributable in a public source repository
- [ ] Replaced with original or verified redistributable assets
- [ ] Removed and documented import/acquisition steps
- [ ] `NOTICE.md` updated
- [ ] `docs/third-party-assets.md` updated
- [ ] `docs/asset-removal-plan.md` updated if references changed
- [ ] Unity scene validation rerun
- [ ] Release audit rerun
