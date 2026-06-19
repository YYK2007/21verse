param(
    [string] $ProjectPath = (Join-Path $PSScriptRoot "..\unity\21verse-vr-game-hub"),
    [string] $OutputPath = (Join-Path $PSScriptRoot "..\docs\inventory\unity-risky-asset-references.csv")
)

$ErrorActionPreference = "Stop"

$riskyFolders = @(
    "BuildingMaterials",
    "Fantasy Skybox FREE",
    "Fresh_Raystore",
    "Lana Studio",
    "Samples",
    "Sprites",
    "TextMesh Pro",
    "VRTemplateAssets",
    "WOC"
)

$scanExtensions = @(".unity", ".prefab", ".mat", ".asset", ".controller", ".playable", ".anim", ".overrideController")
$assetsPath = (Resolve-Path -LiteralPath (Join-Path $ProjectPath "Assets")).Path
$resolvedOutput = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputPath)

$candidateFiles = @(Get-ChildItem -LiteralPath $assetsPath -Recurse -Force -File |
    Where-Object { $scanExtensions -contains $_.Extension })

$rows = foreach ($folderName in $riskyFolders) {
    $folderPath = Join-Path $assetsPath $folderName
    if (-not (Test-Path -LiteralPath $folderPath)) {
        [PSCustomObject]@{
            folder = "Assets/$folderName"
            guid_count = 0
            external_reference_count = 0
            referenced_by = ""
            note = "Folder not present."
        }
        continue
    }

    $guids = @(Get-ChildItem -LiteralPath $folderPath -Recurse -Force -File -Filter *.meta |
        ForEach-Object {
            Select-String -LiteralPath $_.FullName -Pattern '^guid:\s*([a-fA-F0-9]+)' -ErrorAction SilentlyContinue |
                ForEach-Object { $_.Matches[0].Groups[1].Value }
        } | Sort-Object -Unique)

    $references = [System.Collections.Generic.List[string]]::new()

    foreach ($file in $candidateFiles) {
        if ($file.FullName.StartsWith($folderPath, [System.StringComparison]::OrdinalIgnoreCase)) {
            continue
        }

        $content = Get-Content -LiteralPath $file.FullName -Raw -ErrorAction SilentlyContinue
        if ([string]::IsNullOrEmpty($content)) {
            continue
        }

        foreach ($guid in $guids) {
            if ($content.Contains($guid)) {
                $relative = $file.FullName.Substring($assetsPath.Length + 1) -replace '\\', '/'
                $references.Add("Assets/$relative") | Out-Null
                break
            }
        }
    }

    $uniqueReferences = @($references | Sort-Object -Unique)
    $sample = ($uniqueReferences | Select-Object -First 20) -join "; "
    $note = if ($uniqueReferences.Count -eq 0) {
        "No external serialized references found in scanned Unity files."
    }
    elseif ($uniqueReferences.Count -gt 20) {
        "Showing first 20 referenced files."
    }
    else {
        "All referenced files shown."
    }

    [PSCustomObject]@{
        folder = "Assets/$folderName"
        guid_count = $guids.Count
        external_reference_count = $uniqueReferences.Count
        referenced_by = $sample
        note = $note
    }
}

$outputDir = Split-Path -Parent $resolvedOutput
New-Item -ItemType Directory -Force -Path $outputDir | Out-Null
$tempOutput = Join-Path $env:TEMP ("unity-risky-asset-references-" + [guid]::NewGuid().ToString("N") + ".csv")
$rows | Export-Csv -LiteralPath $tempOutput -NoTypeInformation

$existingOutput = Get-Item -LiteralPath $resolvedOutput -ErrorAction SilentlyContinue
if ($existingOutput) {
    $existingText = Get-Content -LiteralPath $resolvedOutput -Raw
    $newText = Get-Content -LiteralPath $tempOutput -Raw
    if ($existingText -eq $newText) {
        Remove-Item -LiteralPath $tempOutput -Force
        Write-Output $resolvedOutput
        return
    }
}

Move-Item -LiteralPath $tempOutput -Destination $resolvedOutput -Force
Write-Output $resolvedOutput
