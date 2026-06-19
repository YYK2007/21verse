# Private GitHub Repo Handoff

The local repo is committed and ready to push from:

`C:\Users\youss\OneDrive\Documents\21verse_opensource`

Current branch:

`main`

Current commit:

`505fd00 Prepare 21Verse open-source staging repo`

## Required GitHub Settings

Create the GitHub repository as private.

Recommended name:

`21verse_opensource`

Recommended owner:

`YYK2007`

Do not initialize the GitHub repo with a README, license, or `.gitignore`; those already exist locally.

## Push Commands

After creating the private GitHub repository:

```powershell
cd C:\Users\youss\OneDrive\Documents\21verse_opensource
git remote add origin https://github.com/YYK2007/21verse_opensource.git
git push -u origin main
git lfs push origin main
```

## Verification Commands

```powershell
git status --short --branch
git remote -v
git lfs ls-files | Measure-Object
```

Expected local status before pushing:

- Branch is `main`.
- Working tree is clean.
- Git LFS is installed and tracks Unity binary/media assets.

## Tooling Note

During the Codex review on 2026-06-19:

- The GitHub connector could inspect existing repos but did not expose repository creation.
- `gh` was not installed initially.
- `winget` found GitHub CLI but installation did not complete in this session.
- `YYK2007/21verse_opensource` returned 404 through the GitHub connector, so the target repo did not exist at that time or was not accessible to the connector.
