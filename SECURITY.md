# Security Policy

21Verse is currently in a private pre-release staging repository.

## Reporting a Vulnerability

While the repository is private, report suspected vulnerabilities or exposed sensitive material directly to the repository owner through the private project channel.

Do not open public issues for:

- Credentials, API keys, tokens, or private keys.
- Student, testing, research, IRB, financial, investor, partner, or outreach material.
- Private Google Drive exports or NAS files that were not reviewed for public release.

## Release Gate

Before the repository is made public, run:

```powershell
.\tools\run-release-audit.ps1
```

The public release should not proceed while the audit reports blockers.
