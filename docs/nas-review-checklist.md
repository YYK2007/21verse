# Private Archive Review Checklist

This checklist tracks the remaining private archive review work for GitHub issue #1.

Source evidence:

- `docs/design-and-nas-inventory.md`
- `docs/nas-review-runbook.md`
- `docs/inventory/nas-access-log.csv`
- `docs/inventory/nas-review-status.csv`
- `tools/test-nas-access.ps1`

## Current State

Private archive/NAS files are excluded from the current open-source release scope. The committed repository keeps only sanitized review status and does not include private network identifiers or raw scan output.

## Completion Checklist

| Step | Status | Evidence required |
| --- | --- | --- |
| Confirm access method | `blocked` | A private mounted drive or UNC path can be listed by a maintainer without committing the raw path. |
| Run archive inventory export | `pending` | `tools/export-nas-inventory.ps1` writes generated candidate files outside committed docs. |
| Review candidate files | `pending` | Candidate files are classified as include, exclude, or private-only. |
| Promote safe files or document exclusions | `pending` | Repo-worthy files are copied into reviewed locations, or public-safe exclusions are recorded with rationale. |
| Refresh release evidence | `pending` | Public docs reflect the final archive decision without private paths or network details. |

## Review Rules

- Do not commit raw archive exports from `docs/inventory/generated/`; summarize reviewed results in tracked docs.
- Keep testing, IRB, financial, investor, partner, proposal, outreach, and participant materials private unless deliberately redacted.
- Do not copy generated Unity folders such as `Library`, `Temp`, `Logs`, `Obj`, `Build`, `Builds`, or `UserSettings`.
- Prefer source files only when ownership and public-release rights are clear.

Issue #1 can remain closed for the current release because private archive files are out of scope. Reopen it only if maintainers decide to review and add archive-derived public files.
