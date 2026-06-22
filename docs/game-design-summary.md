# Game Design Summary

21Verse is an immersive learning platform for accessible education and life-skills practice. The selected Unity work in this repository focuses on short, structured VR modules for learners with Down syndrome and other intellectual disabilities, especially in Arabic-speaking educational settings.

## Product Direction

21Verse turns specific educational and functional goals into repeatable VR activities. The broader product direction spans academic skills, language practice, daily living skills, onboarding, and future health-support experiences. This repository contains selected Unity scenes from that work.

## Current Experience Areas

- Mathematics: number sequences, number comparison, inequality signs, and arithmetic-oriented practice flows.
- Language: Arabic word completion, letter-shape recognition, adjective/attribute identification, and future verb-to-action mapping patterns.
- Daily living: cashier and supermarket-style practice for scanning items, reading prices, and handling money.
- Recognition tasks: color and object identification with simple visual prompts.
- Onboarding patterns: repeated interaction grammar so learners build comfort with VR controls over time.

## Design Principles

- Keep one clear skill at the center of each module.
- Use large, visually dominant prompts and answer targets.
- Prefer spoken prompts or symbolic cues over text-heavy instructions.
- Limit background clutter so the target concept is easy to identify.
- Build difficulty gradually through levels and small variations.
- Reuse interaction patterns across modules to reduce cognitive load.
- Use real-world contexts when they make the practiced skill easier to transfer.

## Unity Implementation

The included Unity project contains scene-based prototypes and interaction scripts. The scenes use straightforward UI, serialized content, and simple controller logic so contributors can inspect, adjust, and extend modules without needing a large backend.

Key scene families include:

- `WordLevel01`
- `AdjectiveLevel01`
- `IdentifyingColors`
- `NumberLevelUI01`
- `NumberInequalitiesLevel`
- `Cashier`

See `README.md` for setup and `docs/unity-validation.md` for scene validation status.
