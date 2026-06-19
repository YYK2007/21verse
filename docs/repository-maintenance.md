# Repository Maintenance

This private staging repository includes lightweight maintenance automation for the future public release.

## GitHub Automation

- `.github/workflows/repo-hygiene.yml` runs lightweight repository checks on pushes to `main` and pull requests.
- `.github/dependabot.yml` checks GitHub Actions dependencies monthly.
- `.github/CODEOWNERS` assigns release-sensitive areas to the repository owner.

## Unity Dependencies

Unity Package Manager dependencies are tracked in:

- `unity/21verse-vr-game-hub/Packages/manifest.json`
- `unity/21verse-vr-game-hub/Packages/packages-lock.json`
- `docs/unity-dependencies.md`

Dependabot does not manage Unity Package Manager dependencies here. Unity package upgrades should be done manually in Unity `2022.3.25f1`, followed by:

```powershell
.\tools\run-unity-scene-validation.ps1
.\tools\export-unity-asset-audit.ps1
.\tools\export-unity-risky-asset-references.ps1
.\tools\run-release-audit.ps1
```

## Release Audit

The current release gate snapshot is `docs/inventory/release-audit.md`. A public release should not proceed while it reports blockers.
