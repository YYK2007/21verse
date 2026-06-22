# Design Files and Private Archive Inventory

Review date: 2026-06-19.

## Local Design/Document Inventory

Private local 21Verse design and document roots were reviewed during release preparation. Absolute workstation paths are intentionally omitted from the public repository.

Aggregate file counts found in the private design/document roots:

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

Only selected brand/public collateral was copied into the repo. Most private design sources are intentionally not bundled because they are large, duplicate-heavy, and need ownership/license review before any public release.

## Private NAS/Archive Scope

A private NAS/archive source was identified during release preparation, but raw NAS files are excluded from this open-source release. The committed repository does not include the private host name, IP address, share names, credentials, or raw scan output.

If this scope is reopened later, maintainers should:

1. Mount or authenticate to the private archive outside the repository.
2. Inventory candidate 21Verse files without committing raw network evidence.
3. Review candidate files for privacy, ownership, and redistribution rights.
4. Copy only reviewed public-safe files into the repository.
5. Summarize decisions in public docs without private paths, network details, or credentials.
