# 21verse

![21Verse banner](brand/21verse-banner-social.jpg)

`21verse` contains selected Unity VR learning experiences from 21Verse.

21Verse explores accessible, specialist-informed VR education and life-skills practice for learners with Down syndrome and other intellectual disabilities, with an initial focus on Arabic-speaking learning environments. The experiences in this repository translate focused educational goals into simple, repeatable VR activities with clear prompts, low visual noise, limited choices, and consistent interaction patterns.

## Experiences

The Unity project currently includes selected scenes for:

- Arabic word completion and letter-shape practice.
- Attribute and adjective identification, such as tall/short and hot/cold.
- Color and object recognition using fruit-based prompts.
- Number sequences with a missing value.
- Number comparison and inequality practice.
- Arithmetic-oriented UI flows for step-by-step math practice.
- A cashier simulation for scanning items, handling prices, and practicing daily living skills.

## Design Approach

These experiences are built around a few recurring product principles:

- One clear skill per module.
- Large, visually dominant targets and answers.
- Audio-first or symbol-supported instructions.
- Gradual scaffolding so learners can begin at a reachable level.
- Reused interaction patterns so VR navigation does not overshadow the learning goal.
- Real-world context when it helps skills transfer beyond the headset.

## Repository Layout

- `unity/21verse-vr-game-hub/` - Unity project containing the selected scenes and scripts.
- `brand/` - 21Verse brand images used by the repository.
- `docs/` - concise project, validation, dependency, and maintenance notes.
- `tools/` - PowerShell validation scripts.

## Unity Setup

Open `unity/21verse-vr-game-hub` in Unity Hub with Unity `2022.3.25f1`.

Important scenes live under `Assets/Scenes`:

- `MainMenu.unity`
- `WordLevel01.unity`
- `AdjectiveLevel01.unity`
- `IdentifyingColors.unity`
- `NumberLevelUI01.unity`
- `NumberInequalitiesLevel.unity`
- `Cashier.unity`

Unity-generated folders such as `Library`, `Logs`, `Temp`, `Obj`, `Build`, `Builds`, and `UserSettings` are intentionally ignored.

## Validation

Run the repository hygiene check:

```powershell
.\tools\test-repo-hygiene.ps1
```

Run Unity scene validation from a machine with Unity installed:

```powershell
.\tools\run-unity-scene-validation.ps1
```

The scene validation opens the configured scenes in Unity batchmode and checks for missing script components. See `docs/unity-validation.md` for the latest recorded validation summary.

## Documentation

- `docs/game-design-summary.md` - product and experience overview.
- `docs/unity-validation.md` - scene validation status.
- `docs/unity-dependencies.md` - Unity version and package dependencies.
- `docs/third-party-assets.md` - asset and attribution policy.
- `docs/repository-maintenance.md` - maintenance workflow.

## License

Source code and 21Verse-developed scene compositions are released under the MIT License unless a file-level notice says otherwise. Unity packages, platform SDKs, fonts, brand assets, and any third-party assets remain governed by their own license terms. See `NOTICE.md` for details.
