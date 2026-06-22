# Third-Party Assets

This repository is intended to be easy to inspect, clone, and build from source. Keep third-party asset decisions explicit.

## Policy

- Prefer original 21Verse assets, Unity primitives, or assets with clear redistribution rights.
- Do not commit Asset Store, marketplace, downloaded, sample, template, or generated assets unless their license allows redistribution in a public source repository.
- Keep Unity-generated folders out of Git.
- Use Git LFS for binary assets that belong in the repository.
- Update `NOTICE.md` when new third-party assets, fonts, SDKs, or package notices are required.

## Current Asset Areas

Retained project folders include:

- `Assets/Scripts`
- `Assets/Scenes`
- `Assets/IdentifyingColors`
- `Assets/Comparision2D`
- `Assets/Prefabs`
- `Assets/XR`
- `Assets/XRI`
- `Assets/Settings`

Unity Package Manager dependencies are documented in `docs/unity-dependencies.md`.

## Adding Assets

Before adding an asset:

1. Confirm who owns it.
2. Confirm that public source redistribution is allowed.
3. Include required attribution or license text.
4. Keep asset size reasonable and use Git LFS when appropriate.
5. Validate the Unity scenes after import.
