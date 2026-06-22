# GitHub Repo Handoff

The public GitHub repository exists at:

`https://github.com/YYK2007/21verse_opensource`

Local checkout:

`C:\Users\youss\OneDrive\Documents\21verse_opensource`

Default branch:

`main`

The repository was approved for publication after the release audit reported no content blockers. Branch protection should remain enabled after publication.

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
- GitHub repository visibility matches the approved release state.
- GitHub metadata matches `docs/github-metadata.md`.
- Branch protection handoff is documented in `docs/github-branch-protection.md`.
- Release evidence map is present at `docs/release-evidence-manifest.md`.
- Git LFS is installed and tracks Unity binary/media assets.
- `Repo Hygiene` GitHub Actions checks pass, including the public-release visibility guard.
- `tools/test-github-release-state.ps1` passes from a Windows session with GitHub credentials.

## Release Tracker Issues

- [Public release readiness milestone](https://github.com/YYK2007/21verse_opensource/milestone/1)
- [#1 Review 21Verse files on Youssef Storage NAS](https://github.com/YYK2007/21verse_opensource/issues/1)
- [#2 Confirm third-party Unity asset redistribution rights](https://github.com/YYK2007/21verse_opensource/issues/2)
- [#3 Open curated Unity project and smoke test main scenes](https://github.com/YYK2007/21verse_opensource/issues/3)
- [#5 Verify GitHub branch protection before public release](https://github.com/YYK2007/21verse_opensource/issues/5)

See `docs/github-tracker.md` for label and milestone details.
See `docs/github-branch-protection.md` for the branch protection handoff.

## Publication Conditions

- NAS review is complete or explicitly documented as intentionally excluded.
- Third-party Unity assets are confirmed redistributable, replaced, or removed with import/reconstruction instructions.
- Interactive Unity/VR smoke testing is complete or explicitly deferred from the current release-prep scope.
- Google Drive public candidates are redacted before export.
- `docs/release-evidence-manifest.md` has no blocked requirements.
- `docs/inventory/release-audit.md` reports no content blockers.
- Branch protection is enabled through GitHub Pro while private, or applied immediately after the explicitly approved public visibility change.

Repository visibility was approved for public release by user request on 2026-06-22. Keep future private, partner, investor, testing, research, and unsanitized Drive/NAS materials out of public commits.
