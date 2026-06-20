# Unity Attribution Gap Report

This report maps each Unity top-level asset folder to the NOTICE/attribution action required before any public release.

Authoritative generated file:

- `docs/inventory/unity-attribution-gap-report.csv`

Refresh it after any Unity asset, disposition, or NOTICE change:

```powershell
.\tools\export-unity-attribution-gap-report.ps1
```

Summary: 18 asset folders reviewed; 8 defer NOTICE text until final asset decision; 8 retain candidates need owner review before final NOTICE clearance; 1 package/font rows need package-specific review.

This report does not grant redistribution rights. It makes the attribution gap explicit so issue #2 cannot be closed until retained third-party material has matching license and NOTICE evidence.

| Folder | Public treatment | Notice status | Required action |
| --- | --- | --- | --- |
| `Assets/BuildingMaterials` | `replace_before_public_release` | `defer_until_final_asset_decision` | Do not add final NOTICE text yet; first remove, replace, import externally, or confirm redistribution rights for this folder. |
| `Assets/Comparision2D` | `retain_candidate_reviewed` | `owner_review_required_no_folder_notice` | During final public review, add NOTICE/license attribution for any retained non-original files or document the folder as project-owned. |
| `Assets/Editor` | `retain_candidate_reviewed` | `owner_review_required_no_folder_notice` | During final public review, add NOTICE/license attribution for any retained non-original files or document the folder as project-owned. |
| `Assets/Fantasy Skybox FREE` | `exclude_until_import_or_rights_confirmed` | `defer_until_final_asset_decision` | Do not add final NOTICE text yet; first remove, replace, import externally, or confirm redistribution rights for this folder. |
| `Assets/Fresh_Raystore` | `exclude_until_import_or_rights_confirmed` | `defer_until_final_asset_decision` | Do not add final NOTICE text yet; first remove, replace, import externally, or confirm redistribution rights for this folder. |
| `Assets/IdentifyingColors` | `retain_candidate_reviewed` | `owner_review_required_no_folder_notice` | During final public review, add NOTICE/license attribution for any retained non-original files or document the folder as project-owned. |
| `Assets/Lana Studio` | `replace_before_public_release` | `defer_until_final_asset_decision` | Do not add final NOTICE text yet; first remove, replace, import externally, or confirm redistribution rights for this folder. |
| `Assets/Prefabs` | `retain_candidate_reviewed` | `owner_review_required_no_folder_notice` | During final public review, add NOTICE/license attribution for any retained non-original files or document the folder as project-owned. |
| `Assets/Samples` | `exclude_until_import_or_rights_confirmed` | `defer_until_final_asset_decision` | Do not add final NOTICE text yet; first remove, replace, import externally, or confirm redistribution rights for this folder. |
| `Assets/Scenes` | `retain_candidate_reviewed` | `owner_review_required_no_folder_notice` | During final public review, add NOTICE/license attribution for any retained non-original files or document the folder as project-owned. |
| `Assets/Scripts` | `retain_candidate_reviewed` | `owner_review_required_no_folder_notice` | During final public review, add NOTICE/license attribution for any retained non-original files or document the folder as project-owned. |
| `Assets/Settings` | `retain_candidate_reviewed` | `owner_review_required_no_folder_notice` | During final public review, add NOTICE/license attribution for any retained non-original files or document the folder as project-owned. |
| `Assets/Sprites` | `replace_before_public_release` | `defer_until_final_asset_decision` | Do not add final NOTICE text yet; first remove, replace, import externally, or confirm redistribution rights for this folder. |
| `Assets/TextMesh Pro` | `exclude_until_import_or_rights_confirmed` | `pending_package_and_font_review` | Confirm Unity/TextMesh Pro redistribution terms and keep the LiberationSans OFL attribution if bundled font files remain. |
| `Assets/VRTemplateAssets` | `exclude_until_import_or_rights_confirmed` | `defer_until_final_asset_decision` | Do not add final NOTICE text yet; first remove, replace, import externally, or confirm redistribution rights for this folder. |
| `Assets/WOC` | `replace_before_public_release` | `defer_until_final_asset_decision` | Do not add final NOTICE text yet; first remove, replace, import externally, or confirm redistribution rights for this folder. |
| `Assets/XR` | `retain_candidate_reviewed` | `mentioned_but_owner_review_required` | Keep the NOTICE entry only after final owner review confirms retained files are original or redistributable. |
| `Assets/XRI` | `retain_candidate_reviewed` | `owner_review_required_no_folder_notice` | During final public review, add NOTICE/license attribution for any retained non-original files or document the folder as project-owned. |
