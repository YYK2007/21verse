---
name: NAS review
about: Track review of private archive files for possible public-safe additions
title: "NAS review: "
labels: release, inventory
assignees: ""
---

## Access

- Device/share: private maintainer-provided archive location
- Current evidence: `docs/inventory/nas-access-log.csv`

## Checklist

- [ ] Mount or authenticate to the NAS share
- [ ] Search for 21Verse files
- [ ] Inventory candidate Unity projects, design files, documents, decks, and archives
- [ ] Copy only public-safe/repo-worthy files into the staging repo
- [ ] Document excluded private or duplicate files
- [ ] Update `docs/design-and-nas-inventory.md`
- [ ] Update `docs/inventory/nas-access-log.csv`
- [ ] Rerun `tools/run-release-audit.ps1`
