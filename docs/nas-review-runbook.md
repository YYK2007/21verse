# Private Archive Review Runbook

This runbook is for maintainers who may later review private NAS/archive files for possible public-safe additions.

Current public evidence:

- `docs/inventory/nas-access-log.csv`
- `docs/inventory/nas-review-status.csv`
- `docs/design-and-nas-inventory.md`
- `docs/nas-review-checklist.md`

## Access Requirements

The private archive is not part of this open-source release. If maintainers reopen this scope, authenticate or mount the archive outside the repository and avoid committing raw network details, host names, IP addresses, share names, credentials, or unreviewed file listings.

## Refresh Access Evidence

If access needs to be checked, run the probe with explicit local parameters:

```powershell
.\tools\test-nas-access.ps1 -HostName "PrivateNasHost" -Address "0.0.0.0"
```

The probe writes `docs/inventory/nas-access-log.csv`. Before committing, replace raw host, IP, share, and error detail with public-safe summary rows.

## Scan Command

After mounting a share or drive, run:

```powershell
.\tools\export-nas-inventory.ps1 -Roots "Z:\"
```

For a UNC share:

```powershell
.\tools\export-nas-inventory.ps1 -Roots "\\PrivateNasHost\ShareName"
```

The script writes generated files under `docs/inventory/generated/`. Do not commit raw generated NAS exports.

## Review Rules

1. Review candidate files before copying anything into the repository.
2. Keep testing, IRB, financial, investor, partner, proposal, outreach, and participant materials private unless deliberately redacted.
3. Do not copy generated Unity folders such as `Library`, `Temp`, `Logs`, `Obj`, `Build`, `Builds`, or `UserSettings`.
4. Prefer source files only when ownership and public-release rights are clear.
5. Promote only reviewed, public-safe findings into committed docs or repo files.
6. Commit only summarized public-safe evidence.
7. Rerun:

```powershell
.\tools\test-repo-hygiene.ps1
.\tools\run-release-audit.ps1
```
