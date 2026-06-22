# Contributing

Thanks for helping improve `21verse`.

This repository focuses on selected Unity VR learning experiences from 21Verse. Contributions are most useful when they improve the included scenes, scripts, documentation, setup flow, validation, accessibility, or asset clarity.

Please follow `CODE_OF_CONDUCT.md` in issues, pull requests, reviews, and discussions.

## Development Setup

1. Install Unity `2022.3.25f1`.
2. Open `unity/21verse-vr-game-hub` in Unity Hub.
3. Let Unity regenerate local folders such as `Library`, `Temp`, `Logs`, and `UserSettings`.
4. Keep generated folders out of Git.
5. Keep large binary assets under Git LFS according to `.gitattributes`.

## Pull Requests

Before opening a pull request:

- Describe the experience, scene, or workflow affected.
- Keep changes focused and easy to review.
- Include screenshots or short clips for visible scene/UI changes when possible.
- Update docs when setup, validation, dependencies, or asset requirements change.

Run the checks that match your change:

```powershell
.\tools\test-repo-hygiene.ps1
.\tools\run-unity-scene-validation.ps1
```

## Unity Asset Policy

- Prefer original, project-owned, or clearly redistributable assets.
- Do not add Asset Store, marketplace, downloaded, sample, or generated assets unless their license allows redistribution in a public source repository.
- Document new package dependencies in `docs/unity-dependencies.md`.
- Update `NOTICE.md` and `docs/third-party-assets.md` when asset or attribution details change.

## Accessibility And Learning Design

21Verse experiences should stay focused and approachable:

- Keep one primary learning goal per module.
- Use large, clear targets and answer choices.
- Favor audio-first or symbol-supported instructions.
- Limit background clutter and unnecessary motion.
- Keep interactions consistent across scenes where possible.
- Add difficulty gradually rather than jumping between skill levels.
