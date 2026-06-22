# Google Drive Public-Release Plan

This plan turns the curated Google Drive inventory into public-release decisions for docs, decks, and sheets. It records file names and release decisions without storing private Drive links in the public repository.

Source files:

- `docs/inventory/google-drive-21verse.csv`
- `docs/inventory/google-drive-release-plan.csv`
- `docs/inventory/google-drive-public-manifest.csv`
- `docs/google-drive-public-manifest.md`

Regenerate the decision CSV with:

```powershell
.\tools\export-google-drive-release-plan.ps1
.\tools\export-google-drive-public-manifest.ps1
```

## Current Summary

The current Drive release plan classifies 35 inventoried files:

| Decision | Count | Meaning |
| --- | ---: | --- |
| `exclude_private` | 16 | Keep out of the public repo. These include investor, partner, research/IRB, testing, pilot, financial, vendor, strategy, and outreach material. |
| `sanitize_then_export_candidate` | 13 | Possible public collateral after redaction, owner review, and export. Mostly public-facing presentations, event decks, posters, and selected pitch/showcase material. |
| `summarize_or_redact` | 3 | Potentially useful only as a sanitized summary or redacted derivative. |
| `review_before_export` | 1 | Needs manual judgment before any public export. |
| `already_included` | 1 | A local public-facing export is already staged in the repo. |
| `already_summarized` | 1 | A sanitized derivative is already staged in the repo. |

## Already Staged

- `Poster 2 for 21Verse` is represented by `docs/poster-2.pdf`.
- `21Verse Game Design Document [May 2024]` is represented by `docs/game-design-summary.md`.

## Public Candidate Workflow

1. Pick one `sanitize_then_export_candidate` or `summarize_or_redact` row from `docs/inventory/google-drive-release-plan.csv`.
2. Review the source file for personal contact details, partner names, investor claims, financial details, user/testing data, research participant details, comments, and speaker notes.
3. Export only a redacted public-safe derivative into `docs/`.
4. Update `docs/google-drive-inventory.md`, `docs/inventory/google-drive-21verse.csv`, and `docs/inventory/google-drive-release-plan.csv`.
5. Regenerate `docs/inventory/google-drive-public-manifest.csv`.
6. Run:

```powershell
.\tools\export-google-drive-release-plan.ps1
.\tools\export-google-drive-public-manifest.ps1
.\tools\test-repo-hygiene.ps1
.\tools\run-release-audit.ps1
```

## Exclusion Rule

Files marked `exclude_private` should remain in Google Drive and out of this repository unless the owner deliberately creates a sanitized derivative for public release.
