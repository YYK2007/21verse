# NAS Review Runbook

This runbook is for completing the `Youssef Storage` / `WDMyCloudEX4100` review once the NAS is mounted or authenticated.

Current NAS access evidence:

- `docs/inventory/nas-access-log.csv`
- `docs/inventory/nas-review-status.csv`
- `docs/design-and-nas-inventory.md`
- `docs/nas-review-checklist.md`

## Access Requirements

The NAS was reachable on the LAN as `WDMyCloudEX4100` at `192.168.0.104`, but shares were not accessible from this session. Complete one of these before scanning:

- Mount a NAS share in Windows Explorer or with `net use`.
- Add valid SMB credentials for `WDMyCloudEX4100`.
- Deliberately enable any required guest-access policy yourself if that is the intended NAS setup.

## Refresh Access Evidence

Before retrying the full inventory, refresh the access log:

```powershell
.\tools\test-nas-access.ps1
```

The probe writes `docs/inventory/nas-access-log.csv` and checks active SMB mappings, NetBIOS identity, common NAS ports, UNC root listing, `net view`, and the WD web UI root. It does not store credentials or copy NAS files. If OneDrive temporarily locks the tracked CSV, the script exits successfully and prints the temp CSV path it could not promote.

If you know the exact share name, test it directly:

```powershell
Test-Path "\\WDMyCloudEX4100\ShareName"
.\tools\export-nas-inventory.ps1 -Roots "\\WDMyCloudEX4100\ShareName"
```

## Scan Command

After mounting a share or drive, run:

```powershell
.\tools\export-nas-inventory.ps1 -Roots "Z:\"
```

For a UNC share:

```powershell
.\tools\export-nas-inventory.ps1 -Roots "\\WDMyCloudEX4100\ShareName"
```

The script writes:

- `docs/inventory/generated/nas-candidate-files.csv`
- `docs/inventory/generated/nas-scan-log.csv`

## Review Rules

1. Review candidate files before copying anything into the repository.
2. Keep testing, IRB, financial, investor, partner, proposal, and outreach files private unless deliberately redacted.
3. Do not copy generated Unity folders such as `Library`, `Temp`, `Logs`, `Obj`, `Build`, `Builds`, or `UserSettings`.
4. Prefer source files only when ownership and public-release rights are clear.
5. Promote only reviewed, public-safe NAS findings into committed docs or repo files.
6. Update `docs/inventory/nas-review-status.csv`, `docs/design-and-nas-inventory.md`, and `docs/public-release-runbook.md` after the NAS review is complete.
7. Rerun:

```powershell
.\tools\test-repo-hygiene.ps1
.\tools\run-release-audit.ps1
```
