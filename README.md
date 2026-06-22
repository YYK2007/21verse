# 21verse

This repository is the open-source release of selected Unity work from 21Verse. It is not the full private 21Verse project, company archive, research program, partner archive, or Drive/NAS workspace.

21Verse is a broader immersive learning and health-support platform for people with Down syndrome and other intellectual disabilities, with an initial focus on Arabic-speaking educational settings. The private research, IRB, pitch, and partner materials frame the project as specialist-informed, culturally localized VR for education, therapy-oriented practice, and daily living skills. This public repository exposes only the release-safe Unity source, scene compositions, selected brand assets, and documentation needed to understand and maintain the open-source slice.

## What Is Included

- Curated Unity scenes and scripts for 21Verse learning/gameplay prototypes.
- Public-safe documentation about release scope, asset decisions, validation, and maintenance.
- Selected 21Verse brand assets approved for this repository.

The included Unity work covers parts of the current 21Verse module library: Arabic word completion and letter-shape practice, adjective/attribute identification, color/object recognition, number sequences, number and quantity comparison, arithmetic-oriented UI flows, and a cashier/life-skills simulation.

## What Is Not Included

- Private Google Drive docs, research proposals, IRB materials, pitch decks, partner materials, testing notes, student data, financials, and outreach files.
- Raw NAS files or private archives.
- Downloaded, Asset Store, sample, template, or uncertain-rights Unity asset folders unless redistribution rights are confirmed.

Those private materials may inform the project context, but their links and raw contents are deliberately excluded from this open-source release.

## Project Context

21Verse is designed around repeatable, accessible VR experiences that translate real educational and functional goals into structured practice. The broader program uses feedback from special-education specialists, classroom testing, and research planning to refine modules before deeper pilots or controlled studies.

Design principles reflected in this release include:

- Co-design with educators and specialists rather than building modules in isolation.
- One clear skill per module, with low visual noise and limited answer choices.
- Audio-first or symbol-supported instructions for learners who may not rely on written text.
- Multi-level scaffolding so learners with different baselines can start at a reachable level.
- Consistent interaction patterns across modules so VR literacy does not overshadow the target skill.
- Privacy-first release boundaries for research, IRB, testing, partner, and student materials.

## Repository Layout

- `unity/21verse-vr-game-hub/` - curated Unity project for the public release.
- `brand/` - selected public 21Verse brand images.
- `docs/` - public-safe release notes, inventories, validation evidence, and maintenance docs.
- `tools/` - PowerShell scripts for release review, Unity validation, and repo hygiene.

## Unity Project

Open `unity/21verse-vr-game-hub` in Unity Hub using Unity `2022.3.25f1`.

Important scenes live under:

- `Assets/Scenes/MainMenu.unity`
- `Assets/Scenes/WordLevel01.unity`
- `Assets/Scenes/AdjectiveLevel01.unity`
- `Assets/Scenes/IdentifyingColors.unity`
- `Assets/Scenes/NumberLevelUI01.unity`
- `Assets/Scenes/NumberInequalitiesLevel.unity`
- `Assets/Scenes/Cashier.unity`

These scenes, scripts, layout work, and educational interaction structures are treated as 21Verse-developed project work in this repository. Unity-generated folders such as `Library`, `Logs`, `Temp`, `Obj`, `Build`, `Builds`, and `UserSettings` are intentionally excluded.

## Validation And Maintenance

The repository includes scripts for maintainers who need to rerun the release checks:

```powershell
.\tools\test-repo-hygiene.ps1
.\tools\run-unity-scene-validation.ps1
.\tools\run-release-audit.ps1
.\tools\test-github-release-state.ps1
```

Detailed release evidence and maintenance notes live in:

- `docs/open-source-review.md`
- `docs/release-readiness.md`
- `docs/release-evidence-manifest.md`
- `docs/github-metadata.md`
- `docs/github-repo-handoff.md`
- `docs/unity-validation.md`
- `docs/third-party-assets.md`
- `docs/google-drive-release-plan.md`
- `docs/google-drive-public-manifest.md`
- `docs/repository-maintenance.md`

## License

Code and 21Verse-developed scene compositions are released under the MIT License in `LICENSE` unless another file-level notice says otherwise. Brand assets, screenshots, presentations, research materials, partner materials, and any future third-party Unity assets may have separate ownership or license terms; see `NOTICE.md` and `docs/open-source-review.md`.
