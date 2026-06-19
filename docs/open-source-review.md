# Open-Source Review

Status: private staging repository prepared on 2026-06-19.

## Included

- Main Unity project copied from `C:\Users\youss\Desktop\21Verse\21VerseVRGameHub-adjectives-game\21VerseVRGameHub-with-more`.
- Selected brand assets copied from `C:\Users\youss\Desktop\21Verse`.
- Public-facing poster PDF copied as `docs/poster-2.pdf`.
- Repository docs, ignore rules, Git LFS patterns, license, and notices.

## Excluded

- Unity generated folders: `Library`, `Logs`, `Temp`, `Obj`, `Build`, `Builds`, `UserSettings`.
- Local IDE files: `.vscode`, `.vs`, `.csproj`, `.sln`, user prefs.
- Private Google Drive folders: Financials, Testing Notes/Insights, Research, Proposals, and Decks.
- Investor, partner, testing, pilot, financial, and outreach documents unless explicitly sanitized later.
- Backup archives and duplicate project zips/rar files.

## Publication Blockers

- Third-party Unity assets need license review before public release. See `docs/third-party-assets.md`.
- Brand assets are included for private staging, but public reuse terms should be stated before release.
- The Google Drive materials contain business, research, testing, and financial files. Keep them out of the public repo unless redacted.
- Confirm whether MIT is the desired code license before making the repo public.
- Push to a private GitHub repository after the repo exists. See `docs/github-private-repo.md`.
- Review private tracker issues before public release:
  - https://github.com/YYK2007/21verse_opensource/issues/1
  - https://github.com/YYK2007/21verse_opensource/issues/2
  - https://github.com/YYK2007/21verse_opensource/issues/3
- Unity batchmode open/import has passed; see `docs/unity-validation.md`.

## Recommended Release Steps

1. Open `unity/21verse-vr-game-hub` interactively in Unity `2022.3.25f1`.
2. Run through the main scenes listed in `README.md` and review shader fallback warnings.
3. Replace any non-redistributable third-party assets with package dependencies, placeholders, or links.
4. Confirm final code and asset licensing.
5. Push to a private GitHub repository.
6. Only after review, change GitHub visibility from private to public.
