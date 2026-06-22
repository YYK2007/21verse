# Google Drive Public Manifest

This manifest converts the Google Drive release plan into a public/private export gate for each inventoried Drive file. It intentionally omits private Drive URLs.

Authoritative generated file:

- `docs/inventory/google-drive-public-manifest.csv`

Refresh it with:

```powershell
.\tools\export-google-drive-release-plan.ps1
.\tools\export-google-drive-public-manifest.ps1
```

## Export Gates

- `keep_private_no_public_export`: keep the Drive file out of the public repository.
- `already_staged_public_derivative`: a public-facing local derivative is already in this repo.
- `already_staged_sanitized_summary`: a sanitized local summary is already in this repo.
- `sanitize_and_owner_review_before_export`: export only after owner review and redaction.
- `summarize_or_redact_before_export`: create a public-safe summary or redacted derivative only.
- `manual_review_before_export`: decide manually before any export.

This manifest does not authorize exporting private Drive material. It is a release-review aid for keeping sensitive decks, docs, sheets, testing, investor, partner, and outreach files out of the future public repo unless the owner deliberately creates a sanitized derivative.
