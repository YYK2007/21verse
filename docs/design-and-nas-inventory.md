# Design Files and NAS Inventory

Review date: 2026-06-19.

## Local Design/Document Inventory

Scanned local 21Verse roots:

- `C:\Users\youss\Desktop\21Verse`
- `C:\Users\youss\Desktop\Current Projects\21Verse Design`
- `C:\Users\youss\Desktop\Current Projects\21Verse at GHE`

Design/document file counts found in those roots:

| Extension | Count | Approx. size |
| --- | ---: | ---: |
| `.ai` | 114 | 29.1 MB |
| `.blend` | 3 | 3.2 MB |
| `.docx` | 17 | 23.5 MB |
| `.fbx` | 2,941 | 1,400.8 MB |
| `.jpeg` | 18 | 7.7 MB |
| `.jpg` | 330 | 530.4 MB |
| `.obj` | 3,083 | 44.4 MB |
| `.pdf` | 85 | 319.2 MB |
| `.png` | 53,727 | 7,988.7 MB |
| `.psd` | 736 | 1,780.9 MB |

Only selected brand/public collateral was copied into the repo. Most design sources are intentionally not bundled yet because they are large, duplicate-heavy, and need ownership/license review before public release.

## NAS: Youssef Storage

The NAS named by the user as `Youssef Storage` appears on the LAN as:

- Hostname: `WDMyCloudEX4100`
- Reverse DNS: `WDMyCloudEX4100`
- IP: `192.168.0.104`
- NetBIOS name: `WDMYCLOUDEX4100`
- Device type clue: WD My Cloud EX4100

Evidence:

- `arp -a` showed `192.168.0.104`.
- `nbtstat -A 192.168.0.104` returned `WDMYCLOUDEX4100`.
- `Resolve-DnsName 192.168.0.104` returned `WDMyCloudEX4100`.
- Ports `445`, `139`, and `80` responded.
- Windows Credential Manager has a saved credential target for `WDMYCLOUDEX4100` with user `admin`.

Access result from this session:

- No active SMB mapping existed in `Get-SmbMapping` or `net use`.
- `\\192.168.0.104\Public` was blocked by Windows because unauthenticated guest access is disabled.
- Attempts to connect to likely shares through the hostname timed out or failed.
- The saved credential did not produce a successful share listing from this non-interactive session.

Conclusion:

The NAS is reachable, but its shares were not accessible for file review in this session. Reviewing NAS-hosted 21Verse files still requires either valid NAS share credentials in the current Windows session, a mounted drive/share, or a deliberate Windows SMB guest-access policy change by the user.
