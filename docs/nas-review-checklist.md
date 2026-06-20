# NAS Review Checklist

This checklist tracks the remaining `Youssef Storage` / `WDMyCloudEX4100` work for GitHub issue #1.

Source evidence:

- `docs/design-and-nas-inventory.md`
- `docs/nas-review-runbook.md`
- `docs/inventory/nas-access-log.csv`
- `docs/inventory/nas-review-status.csv`
- `tools/test-nas-access.ps1`

## Current State

The NAS is reachable on the local network as `WDMyCloudEX4100` / `192.168.0.104`, but shares were not accessible from this repo-prep session. The current blocker is authenticated share access or an exact listable share path, not network discovery.

## Completion Checklist

| Step | Status | Evidence required |
| --- | --- | --- |
| Confirm access method | `blocked` | A mounted drive letter or UNC share path that can be listed from this Windows session. |
| Run NAS inventory export | `pending` | `tools/export-nas-inventory.ps1` writes `docs/inventory/generated/nas-candidate-files.csv` and `docs/inventory/generated/nas-scan-log.csv`. |
| Review candidate files | `pending` | Candidate files are classified as include, exclude, or private-only. |
| Promote safe files or document exclusions | `pending` | Repo-worthy files are copied into reviewed locations, or exclusions are recorded with rationale. |
| Refresh release evidence | `pending` | `docs/design-and-nas-inventory.md`, this checklist, issue #1, and `docs/inventory/release-audit.md` reflect the final NAS decision. |

## Review Rules

- Do not commit raw NAS exports from `docs/inventory/generated/`; summarize reviewed results in tracked docs.
- Keep testing, IRB, financial, investor, partner, proposal, and outreach materials private unless deliberately redacted.
- Do not copy generated Unity folders such as `Library`, `Temp`, `Logs`, `Obj`, `Build`, `Builds`, or `UserSettings`.
- Prefer source files only when ownership and public-release rights are clear.

Issue #1 can close only when every row in `docs/inventory/nas-review-status.csv` is `complete`, NAS candidate results have been reviewed, and the release audit no longer marks the NAS review as a blocker.
