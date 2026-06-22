# Open-Source Review

Status: public open-source release prepared from the curated 21Verse project.

## Included

- Main Unity project copied from a reviewed private local 21Verse source project.
- 21Verse-developed Unity scene compositions, including the main learning/gameplay scenes listed in `README.md`.
- Selected brand assets copied from reviewed private local 21Verse brand sources.
- Public-facing poster PDF copied as `docs/poster-2.pdf`.
- Repository docs, ignore rules, Git LFS patterns, license, and notices.

## Excluded

- Unity generated folders: `Library`, `Logs`, `Temp`, `Obj`, `Build`, `Builds`, `UserSettings`.
- Local IDE files: `.vscode`, `.vs`, `.csproj`, `.sln`, user prefs.
- Private Google Drive folders: Financials, Testing Notes/Insights, Research, Proposals, and Decks.
- Investor, partner, testing, pilot, financial, and outreach documents unless explicitly sanitized later.
- Backup archives and duplicate project zips/rar files.

## Release Decisions

- Downloaded, Asset Store, sample, template, and uncertain-rights Unity asset folders were removed from the public release. See `docs/third-party-assets.md`.
- The main scenes are 21Verse-developed compositions. Public redistribution covers the 21Verse scene/script/layout work in this repo, not any private excluded asset imports.
- Brand assets are included as selected public-facing 21Verse materials; reuse terms are stated in `NOTICE.md`.
- The Google Drive materials contain business, research, testing, and financial files. Keep them out of the public repo unless redacted.
- Code is released under MIT unless a file-level notice says otherwise.
- GitHub repository state is tracked in `docs/github-repo-handoff.md`.
- Release tracker issues:
  - https://github.com/YYK2007/21verse/issues/1
  - https://github.com/YYK2007/21verse/issues/2
  - https://github.com/YYK2007/21verse/issues/3
- Unity batchmode open/import has passed; see `docs/unity-validation.md`.

## Future Maintenance Steps

1. Open `unity/21verse-vr-game-hub` interactively in Unity `2022.3.25f1`.
2. Run through the main scenes listed in `README.md` and review shader fallback warnings.
3. Keep non-redistributable third-party assets out of the public repo unless rights are confirmed.
4. Reconfirm code and asset licensing after any future imported asset change.
5. Keep private Drive/NAS materials out of public commits unless a sanitized derivative is deliberately created.
