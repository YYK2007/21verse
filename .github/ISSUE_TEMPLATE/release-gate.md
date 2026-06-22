---
name: Release gate
about: Verify the public release gate before publishing future release changes
title: "Release gate: "
labels: release
assignees: ""
---

## Release Audit

- Snapshot: `docs/inventory/release-audit.md`
- Command:

```powershell
.\tools\run-release-audit.ps1
```

## Required Checks

- [ ] NAS review complete
- [ ] Third-party asset decisions complete
- [ ] Unity scene validation passes
- [ ] Interactive gameplay/VR smoke test complete
- [ ] Secret scan reviewed
- [ ] No non-LFS file exceeds GitHub's 100 MB limit
- [ ] Google Drive exports are sanitized or intentionally excluded
- [ ] `NOTICE.md` reflects final asset/licensing decisions
- [ ] GitHub repository visibility and branch protection match the approved release state
