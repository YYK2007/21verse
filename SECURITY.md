# Security Policy

## Reporting A Vulnerability

Report suspected vulnerabilities or exposed sensitive material privately to the repository owner or project maintainers. Do not open public issues for:

- Credentials, API keys, tokens, or private keys.
- Student, testing, research, IRB, financial, investor, partner, or outreach material.
- Private Google Drive exports or NAS files that were not reviewed for public release.

## Release Gate

After any release-scope change, rerun the release audit:

```powershell
.\tools\run-release-audit.ps1
```

Do not publish release-scope changes while the audit reports blockers.
