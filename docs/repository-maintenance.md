# Repository Maintenance

This repository keeps maintenance lightweight and public-facing.

## Automation

- `.github/workflows/repo-hygiene.yml` runs repository hygiene checks on pull requests and pushes to `main`.
- `.github/dependabot.yml` checks GitHub Actions dependencies monthly.
- `.github/CODEOWNERS` identifies maintainers for reviewed areas.

## Local Checks

Run:

```powershell
.\tools\test-repo-hygiene.ps1
```

When Unity scenes, scripts, packages, or assets change, also run:

```powershell
.\tools\run-unity-scene-validation.ps1
```

## Unity Generated Files

Do not commit Unity-generated folders such as:

- `Library`
- `Logs`
- `Temp`
- `Obj`
- `Build`
- `Builds`
- `UserSettings`

Unity will regenerate them locally.

## Documentation Updates

Update the relevant docs when changing:

- Project setup or Unity version: `README.md` and `docs/unity-dependencies.md`
- Scene validation status: `docs/unity-validation.md`
- Asset policy or attribution: `NOTICE.md` and `docs/third-party-assets.md`
- Contributor workflow: `CONTRIBUTING.md`
