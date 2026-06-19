# Release Audit

Generated: 2026-06-19 22:34:53 +03:00

This audit is a local verification snapshot for the private staging repo. A `blocker` status means the repo must not be made public yet.

| Gate | Status | Evidence | Next step |
| --- | --- | --- | --- |
| Git working tree | pass | ## main...origin/main | Commit, discard, or document all local changes. |
| GitHub remote main | pass | 0b95d7e15542d23e949604b34f5d22151c272ff3	refs/heads/main | Restore origin/main tracking. |
| Non-LFS >100 MB file check | pass | No non-generated files over 100 MB found. | Move oversized files to Git LFS or remove them. |
| Secret scan | pass | Only expected documentation matches found. | Investigate and remove any real secret material. |
| Required handoff docs | pass | All expected handoff docs and inventories are present. | Restore missing docs. |
| Unity batchmode scene validation | pass | Scene validator script present: True; docs record zero missing script references: True. | Run tools/run-unity-scene-validation.ps1 and update docs/unity-validation.md. |
| Unity third-party asset release decisions | blocker | 18 asset folders audited; 9 folders still need rights/replacement decisions; 9 risky folders have serialized references. | Resolve issue #2 by confirming rights, replacing referenced assets, removing assets, or documenting import steps. |
| NAS review | blocker | NAS access log records: Get-SmbMapping: no active mapping for Youssef Storage/WDMyCloudEX4100; net use: no active connection; ARP: 192.168.0.104 reachable; NetBIOS: WDMYCLOUDEX4100 registered; Reverse DNS: WDMyCloudEX4100; Open TCP ports: 22 SSH; 80 HTTP; 139/445 SMB; Closed TCP ports: 21 FTP; 443 HTTPS; 548 AFP; 2049 NFS; SMB public share: blocked by Windows guest policy or invalid credential; SSH admin: batch mode denied; password required; WD web UI: HTTP 200 at root; obvious unauthenticated share APIs unavailable | Mount/authenticate to Youssef Storage / WDMyCloudEX4100 and inventory 21Verse files. |
| Google Drive inventory | pass | 35 Google Drive rows inventoried. | Only export public-safe, redacted docs/decks when selected. |

Summary: pass: 7; blocker: 2
