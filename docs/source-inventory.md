# Source Inventory

## Local Sources Reviewed

Primary local folder:

- `C:\Users\youss\Desktop\21Verse`

Additional 21Verse folders:

- `C:\Users\youss\Desktop\Current Projects\21Verse Design`
- `C:\Users\youss\Desktop\Current Projects\21Verse at GHE`

Mounted drives checked:

- `C:` System Disk
- `D:` HDD
- `E:` Old PC

No active SMB/NAS mapping was detected with `Get-SmbMapping` during the first review. The user later identified the NAS as `Youssef Storage`; see `docs/design-and-nas-inventory.md` for the follow-up network evidence and access result.

## Unity Projects Found

The strongest release candidate was:

- `C:\Users\youss\Desktop\21Verse\21VerseVRGameHub-adjectives-game\21VerseVRGameHub-with-more`

Why this one:

- Unity `2022.3.25f1`
- Existing Git history
- Contains the latest adjective/color work
- Smaller and cleaner than the duplicate-heavy `21VerseVRGameHub` folder

Other Unity project markers were found under:

- `C:\Users\youss\Desktop\21Verse\21VerseVRGameHub`
- `C:\Users\youss\Desktop\21Verse\Metaverse Academy Prototyping\21Verse Project copy`
- `C:\Users\youss\Desktop\21Verse\Prototype`
- `C:\Users\youss\Desktop\21Verse\VR Math Game`
- `C:\Users\youss\Desktop\21Verse\VR Math Game (2)`
- `C:\Users\youss\Desktop\21Verse\VR_Unity_Template`
- `C:\Users\youss\Desktop\Current Projects\21Verse Design\21Verse`

Those folders appear to be older prototypes, backups, templates, or much larger asset-heavy environments. They were not copied into this repo.

## Brand/Public Assets Included

- `brand/21verse-logo-final.png`
- `brand/21verse-banner-social.jpg`
- `brand/banner.jpg`
- `docs/poster-2.pdf`

## Local Assets Not Included

- PSD source files
- Pitch decks and proposals
- Backup archives
- Duplicate logos and old banners
- Local project zips/rar files

See `docs/design-and-nas-inventory.md` for aggregate counts of local design/document files.

## Machine-Readable Inventories

- `docs/inventory/unity-projects.csv`
- `docs/inventory/local-design-summary.csv`
- `docs/inventory/google-drive-21verse.csv`
- `docs/inventory/nas-access-log.csv`

The local inventory files can be rebuilt with `tools/rebuild-local-inventories.ps1`.
