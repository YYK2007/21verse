param(
    [string[]] $Roots = @(),
    [string] $OutputPath = (Join-Path $PSScriptRoot "..\docs\inventory\generated\nas-candidate-files.csv"),
    [string] $LogPath = (Join-Path $PSScriptRoot "..\docs\inventory\generated\nas-scan-log.csv")
)

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
$resolvedOutput = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputPath)
$resolvedLog = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($LogPath)

function Get-FileCategory {
    param([System.IO.FileInfo] $File)

    $extension = $File.Extension.ToLowerInvariant()
    switch ($extension) {
        ".unity" { return "unity-scene" }
        ".cs" { return "unity-script" }
        ".prefab" { return "unity-prefab" }
        ".mat" { return "unity-material" }
        ".asset" { return "unity-asset" }
        ".psd" { return "design-source" }
        ".ai" { return "design-source" }
        ".blend" { return "3d-source" }
        ".fbx" { return "3d-asset" }
        ".obj" { return "3d-asset" }
        ".png" { return "image" }
        ".jpg" { return "image" }
        ".jpeg" { return "image" }
        ".pdf" { return "document-export" }
        ".docx" { return "document-source" }
        ".pptx" { return "presentation-source" }
        ".xlsx" { return "spreadsheet-source" }
        ".csv" { return "spreadsheet-export" }
        ".zip" { return "archive" }
        ".rar" { return "archive" }
        ".7z" { return "archive" }
        default { return "other" }
    }
}

function Get-Recommendation {
    param([System.IO.FileInfo] $File)

    $path = $File.FullName.ToLowerInvariant()
    $name = $File.Name.ToLowerInvariant()

    if ($path -match "\\(library|temp|obj|logs|build|builds|usersettings)\\") {
        return "exclude generated Unity/cache output"
    }

    if ($name -match "financial|irb|investor|testing|pilot|proposal|partner|outreach") {
        return "inventory only; likely private"
    }

    if ($File.Extension.ToLowerInvariant() -in @(".zip", ".rar", ".7z")) {
        return "inventory only; inspect archive before copying"
    }

    return "review for repo inclusion"
}

$logRows = [System.Collections.Generic.List[object]]::new()
$candidateRows = [System.Collections.Generic.List[object]]::new()
$candidateColumns = @(
    "root",
    "relative_path",
    "extension",
    "category",
    "size_mb",
    "last_write",
    "recommendation"
)

if ($Roots.Count -eq 0) {
    $mountedNasRoots = @(Get-PSDrive -PSProvider FileSystem |
        Where-Object {
            $_.DisplayRoot -match "21\s*verse|21verse|private\s*archive|nas" -or
            $_.Root -match "21\s*verse|21verse|private\s*archive|nas"
        } |
        ForEach-Object { if ($_.DisplayRoot) { $_.DisplayRoot } else { $_.Root } })

    $Roots = @($mountedNasRoots | Sort-Object -Unique)
}

if ($Roots.Count -eq 0) {
    $logRows.Add([PSCustomObject]@{
        root = ""
        status = "no mounted NAS root found"
        detail = "Pass -Roots with a mounted drive path or UNC share after authenticating to the private archive outside the repository."
    }) | Out-Null
}

$includeExtensions = @(
    "*.unity", "*.cs", "*.prefab", "*.mat", "*.asset",
    "*.psd", "*.ai", "*.fig", "*.sketch", "*.blend", "*.fbx", "*.obj",
    "*.png", "*.jpg", "*.jpeg", "*.pdf", "*.docx", "*.pptx", "*.xlsx", "*.csv",
    "*.zip", "*.rar", "*.7z"
)

foreach ($root in $Roots) {
    if (-not (Test-Path -LiteralPath $root)) {
        $logRows.Add([PSCustomObject]@{
            root = $root
            status = "not accessible"
            detail = "Path does not exist or is not mounted in the current environment."
        }) | Out-Null
        continue
    }

    $logRows.Add([PSCustomObject]@{
        root = $root
        status = "scanning"
        detail = "Enumerating 21Verse candidate files."
    }) | Out-Null

    $files = @(Get-ChildItem -LiteralPath $root -Recurse -Force -File -ErrorAction SilentlyContinue -Include $includeExtensions |
        Where-Object {
            $_.FullName -match "21\s*verse|21verse|twentyoneverse|verse" -or
            $_.DirectoryName -match "21\s*verse|21verse|twentyoneverse|verse"
        })

    foreach ($file in $files) {
        $relative = $file.FullName
        if ($file.FullName.StartsWith($root, [System.StringComparison]::OrdinalIgnoreCase)) {
            $relative = $file.FullName.Substring($root.Length).TrimStart("\", "/")
        }

        $candidateRows.Add([PSCustomObject]@{
            root = $root
            relative_path = $relative
            extension = $file.Extension.ToLowerInvariant()
            category = Get-FileCategory $file
            size_mb = [math]::Round($file.Length / 1MB, 2)
            last_write = $file.LastWriteTime.ToString("s")
            recommendation = Get-Recommendation $file
        }) | Out-Null
    }

    $logRows.Add([PSCustomObject]@{
        root = $root
        status = "complete"
        detail = "Found $($files.Count) candidate files."
    }) | Out-Null
}

$outputDir = Split-Path -Parent $resolvedOutput
New-Item -ItemType Directory -Force -Path $outputDir | Out-Null

function Set-GeneratedTextFile {
    param(
        [string] $Path,
        [string[]] $Lines
    )

    $tempPath = Join-Path $env:TEMP ("nas-inventory-" + [guid]::NewGuid().ToString("N") + ".csv")
    Set-Content -LiteralPath $tempPath -Value $Lines -Encoding UTF8

    Replace-GeneratedFile -SourcePath $tempPath -DestinationPath $Path
}

function Set-GeneratedCsvFile {
    param(
        [string] $Path,
        [object[]] $Rows
    )

    $tempPath = Join-Path $env:TEMP ("nas-inventory-" + [guid]::NewGuid().ToString("N") + ".csv")
    $Rows | Export-Csv -LiteralPath $tempPath -NoTypeInformation

    Replace-GeneratedFile -SourcePath $tempPath -DestinationPath $Path
}

function Replace-GeneratedFile {
    param(
        [string] $SourcePath,
        [string] $DestinationPath
    )

    if (Test-Path -LiteralPath $DestinationPath) {
        $existingText = (Get-Content -LiteralPath $DestinationPath -Raw) -replace "^\uFEFF", ""
        $newText = (Get-Content -LiteralPath $SourcePath -Raw) -replace "^\uFEFF", ""
        if ($existingText -eq $newText) {
            Remove-Item -LiteralPath $SourcePath -Force
            return
        }

        for ($attempt = 1; $attempt -le 5; $attempt++) {
            try {
                Remove-Item -LiteralPath $DestinationPath -Force
                break
            }
            catch {
                if ($attempt -eq 5) {
                    throw
                }
                Start-Sleep -Milliseconds 500
            }
        }
    }

    Move-Item -LiteralPath $SourcePath -Destination $DestinationPath
}

if ($candidateRows.Count -eq 0) {
    Set-GeneratedTextFile -Path $resolvedOutput -Lines @($candidateColumns -join ",")
}
else {
    Set-GeneratedCsvFile -Path $resolvedOutput -Rows @($candidateRows | Sort-Object root, relative_path)
}

Set-GeneratedCsvFile -Path $resolvedLog -Rows @($logRows)

Write-Output $resolvedOutput
Write-Output $resolvedLog
