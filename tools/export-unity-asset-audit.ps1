param(
    [string] $ProjectPath = (Join-Path $PSScriptRoot "..\unity\21verse-vr-game-hub"),
    [string] $OutputPath = (Join-Path $PSScriptRoot "..\docs\inventory\unity-asset-audit.csv")
)

$ErrorActionPreference = "Stop"

$assetsPath = Join-Path $ProjectPath "Assets"
$resolvedAssets = (Resolve-Path -LiteralPath $assetsPath).Path
$resolvedOutput = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputPath)

$releaseActions = @{
    "BuildingMaterials" = "Replace with original or verified-redistributable materials before public release."
    "Comparision2D" = "Likely project-specific; review ownership and keep if original."
    "Editor" = "Project validation utility; keep."
    "Fantasy Skybox FREE" = "Treat as Unity Asset Store content; remove and document import unless redistribution rights are confirmed."
    "Fresh_Raystore" = "Treat as Unity Asset Store content; remove and document import unless redistribution rights are confirmed."
    "IdentifyingColors" = "Likely project-specific; review ownership and keep if original."
    "Lana Studio" = "Confirm source and rights; replace or remove if unknown."
    "Prefabs" = "Likely project-specific; review dependencies on removed assets."
    "Samples" = "Prefer documenting Unity Package Manager sample import instead of bundling."
    "Scenes" = "Project scenes; keep after smoke testing."
    "Scripts" = "Project source code; keep under selected repo license."
    "Settings" = "Project settings/assets; keep after review."
    "Sprites" = "Review sprite ownership; keep only original or redistributable assets."
    "TextMesh Pro" = "Prefer relying on UPM package; retain font license for any bundled font assets."
    "VRTemplateAssets" = "Confirm Unity template/sample redistribution terms; otherwise document template import steps."
    "WOC" = "Confirm source and rights; replace or remove if unknown."
    "XR" = "Project XR configuration; keep after review."
    "XRI" = "Project XR interaction setup; keep after review."
}

$rows = foreach ($folder in Get-ChildItem -LiteralPath $resolvedAssets -Directory | Sort-Object Name) {
    $files = @(Get-ChildItem -LiteralPath $folder.FullName -Recurse -Force -File)
    $licenseFiles = @($files | Where-Object { $_.Name -match '(?i)(license|notice|credits)' })
    $readmeFiles = @($files | Where-Object { $_.Name -match '(?i)(readme|release|package\.txt|_package\.txt)' })
    $metaFiles = @($files | Where-Object { $_.Extension -eq ".meta" })
    $licenseTypes = @(
        foreach ($metaFile in $metaFiles) {
            Select-String -LiteralPath $metaFile.FullName -Pattern "licenseType:" -ErrorAction SilentlyContinue |
                ForEach-Object { $_.Line.Trim() -replace '^licenseType:\s*', '' }
        }
    ) | Sort-Object -Unique

    $relativeEvidence = @($licenseFiles + $readmeFiles |
        Sort-Object FullName -Unique |
        ForEach-Object { $_.FullName.Substring($resolvedAssets.Length + 1) -replace '\\', '/' })

    [PSCustomObject]@{
        folder = "Assets/$($folder.Name)"
        file_count = $files.Count
        size_mb = [math]::Round((($files | Measure-Object Length -Sum).Sum / 1MB), 1)
        license_types = ($licenseTypes -join "; ")
        evidence_files = ($relativeEvidence -join "; ")
        public_release_action = $releaseActions[$folder.Name]
    }
}

$outputDir = Split-Path -Parent $resolvedOutput
New-Item -ItemType Directory -Force -Path $outputDir | Out-Null
$existingOutput = Get-Item -LiteralPath $resolvedOutput -ErrorAction SilentlyContinue
if ($existingOutput) {
    Remove-Item -LiteralPath $resolvedOutput -Force
}
$rows | Export-Csv -LiteralPath $resolvedOutput -NoTypeInformation
Write-Output $resolvedOutput
