# Private GitHub Repo Handoff

The private staging repository exists at:

`https://github.com/YYK2007/21verse_opensource`

Local checkout:

`C:\Users\youss\OneDrive\Documents\21verse_opensource`

Default branch:

`main`

The repository must remain private until the release audit has no blockers.

## Current Verification

Use these commands to verify local and remote state:

```powershell
git status --short --branch
git remote -v
git ls-remote --heads origin main
git lfs ls-files | Measure-Object
.\tools\test-repo-hygiene.ps1
.\tools\run-release-audit.ps1
.\tools\test-github-release-state.ps1
```

Expected state:

- Local branch is `main`.
- Local branch tracks `origin/main`.
- Working tree is clean after generated audit snapshots are committed.
- GitHub repository visibility is `private`.
- GitHub metadata matches `docs/github-metadata.md`.
- Release evidence map is present at `docs/release-evidence-manifest.md`.
- Git LFS is installed and tracks Unity binary/media assets.
- `Repo Hygiene` GitHub Actions checks pass.
- `tools/test-github-release-state.ps1` passes from a Windows session with GitHub credentials.

## Private Tracker Issues

- [Public release readiness milestone](https://github.com/YYK2007/21verse_opensource/milestone/1)
- [#1 Review 21Verse files on Youssef Storage NAS](https://github.com/YYK2007/21verse_opensource/issues/1)
- [#2 Confirm third-party Unity asset redistribution rights](https://github.com/YYK2007/21verse_opensource/issues/2)
- [#3 Open curated Unity project and smoke test main scenes](https://github.com/YYK2007/21verse_opensource/issues/3)

See `docs/github-tracker.md` for label and milestone details.

## Do Not Publish Until

- NAS review is complete or explicitly documented as intentionally excluded.
- Third-party Unity assets are confirmed redistributable, replaced, or removed with import instructions.
- Interactive Unity/VR smoke testing is complete.
- Google Drive public candidates are redacted before export.
- `docs/release-evidence-manifest.md` has no blocked requirements.
- `docs/inventory/release-audit.md` reports no blockers.

Changing repository visibility from private to public is the final step, not a staging step.
