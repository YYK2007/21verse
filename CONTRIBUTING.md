# Contributing

21Verse is currently staged in a private repository for a future open-source release. Contributions should stay private until the release blockers in `docs/release-readiness.md` are resolved.

## Development Setup

1. Install Unity `2022.3.25f1`.
2. Open `unity/21verse-vr-game-hub` in Unity Hub.
3. Let Unity regenerate local folders such as `Library`, `Temp`, `Logs`, and `UserSettings`; these folders are intentionally ignored.
4. Keep large binary assets under Git LFS according to `.gitattributes`.

## Validation

Before opening a pull request or publishing a release candidate, run:

```powershell
.\tools\run-unity-scene-validation.ps1
.\tools\export-unity-asset-audit.ps1
.\tools\export-unity-risky-asset-references.ps1
.\tools\run-release-audit.ps1
```

The scene validation must pass. The release audit may still report blockers while the repo is private; do not make the repo public while blockers remain.

## Asset Policy

- Do not add Asset Store, downloaded, generated, or sample assets to the future public release unless redistribution rights are confirmed.
- Prefer documented import steps or original placeholder assets for third-party packages.
- Update `NOTICE.md`, `docs/third-party-assets.md`, `docs/unity-dependencies.md`, and `docs/asset-removal-plan.md` when asset decisions change.

## Sensitive Material

Do not commit testing data, IRB material, financials, investor decks, partner outreach, credentials, API keys, or raw Google Drive exports unless they have been deliberately sanitized for public release.
