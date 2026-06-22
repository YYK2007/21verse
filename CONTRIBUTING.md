# Contributing

This repository is the public open-source release of selected 21Verse Unity work. Contributions are welcome when they stay inside the public-safe scope described in `README.md` and `docs/release-readiness.md`.

Please follow `CODE_OF_CONDUCT.md` and `SUPPORT.md` when participating in project discussions or reviews.

## Development Setup

1. Install Unity `2022.3.25f1`.
2. Open `unity/21verse-vr-game-hub` in Unity Hub.
3. Let Unity regenerate local folders such as `Library`, `Temp`, `Logs`, and `UserSettings`; these folders are intentionally ignored.
4. Keep large binary assets under Git LFS according to `.gitattributes`.

## Validation

Before opening a pull request or publishing a release candidate, run the checks that match the change scope. Maintainers should run the full set before release-scope changes:

```powershell
.\tools\test-repo-hygiene.ps1
.\tools\run-unity-scene-validation.ps1
.\tools\export-unity-asset-audit.ps1
.\tools\export-unity-risky-asset-references.ps1
.\tools\run-release-audit.ps1
```

The scene validation and repo hygiene checks should pass before merging code or Unity-scene changes. If the release audit reports a blocker, resolve it before publishing release-scope changes.

Unity Package Manager dependency changes should be made in Unity and validated manually; see `docs/repository-maintenance.md`.

## Asset Policy

- Do not add Asset Store, downloaded, generated, or sample assets to this public repository unless redistribution rights are confirmed.
- Prefer documented import steps or original placeholder assets for third-party packages.
- Update `NOTICE.md`, `docs/third-party-assets.md`, `docs/unity-dependencies.md`, and `docs/asset-removal-plan.md` when asset decisions change.

## Sensitive Material

Do not commit testing data, IRB material, financials, investor decks, partner outreach, credentials, API keys, or raw Google Drive exports unless they have been deliberately sanitized for public release.
