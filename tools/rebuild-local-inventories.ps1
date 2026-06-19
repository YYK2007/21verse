param(
    [string[]]$Roots = @(
        "C:\Users\youss\Desktop\21Verse",
        "C:\Users\youss\Desktop\Current Projects\21Verse Design",
        "C:\Users\youss\Desktop\Current Projects\21Verse at GHE",
        "D:\Unity",
        "E:\Users\Yasser\Documents"
    ),
    [string]$OutputDir = "docs\inventory\generated"
)

New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null

$projectFiles = @()
foreach ($root in $Roots) {
    if (Test-Path $root) {
        try {
            $projectFiles += Get-ChildItem -LiteralPath $root -Recurse -Force -ErrorAction SilentlyContinue -Filter ProjectVersion.txt |
                Where-Object { $_.FullName -notmatch "\\(Library|Temp|Obj|Build|Builds|Logs|UserSettings)\\" }
        } catch {
            Write-Warning "Skipped root after enumeration error: $root"
        }
    }
}

$seen = @{}
$projects = foreach ($vf in $projectFiles) {
    $project = Split-Path (Split-Path $vf.FullName -Parent) -Parent
    if ($seen.ContainsKey($project)) { continue }
    $seen[$project] = $true

    $versionLine = (Get-Content $vf.FullName -ErrorAction SilentlyContinue | Select-Object -First 1) -replace "m_EditorVersion: ", ""
    $assets = Join-Path $project "Assets"
    $scripts = if (Test-Path $assets) { (Get-ChildItem -LiteralPath $assets -Recurse -Force -File -Filter *.cs -ErrorAction SilentlyContinue | Measure-Object).Count } else { 0 }
    $scenes = if (Test-Path $assets) { (Get-ChildItem -LiteralPath $assets -Recurse -Force -File -Filter *.unity -ErrorAction SilentlyContinue | Measure-Object).Count } else { 0 }

    [PSCustomObject]@{
        Project = $project
        UnityVersion = $versionLine
        HasGit = Test-Path (Join-Path $project ".git")
        ScriptFiles = $scripts
        SceneFiles = $scenes
        LastWrite = (Get-Item $project).LastWriteTime.ToString("s")
    }
}

$unityOutput = Join-Path $OutputDir "unity-projects.csv"
$designOutput = Join-Path $OutputDir "local-design-summary.csv"

$projects | Sort-Object Project |
    ConvertTo-Csv -NoTypeInformation |
    Set-Content -Encoding UTF8 -Force $unityOutput

$designRoots = $Roots | Where-Object { $_ -like "*21Verse*" -or $_ -like "*21Verse Design*" -or $_ -like "*21Verse at GHE*" }
Get-ChildItem -Path $designRoots -Recurse -Force -File -ErrorAction SilentlyContinue -Include *.psd,*.ai,*.fig,*.sketch,*.blend,*.fbx,*.obj,*.png,*.jpg,*.jpeg,*.pdf,*.docx,*.pptx |
    Group-Object Extension |
    Sort-Object Name |
    ForEach-Object {
        [PSCustomObject]@{
            Extension = $_.Name
            Count = $_.Count
            SizeMB = [math]::Round(($_.Group | Measure-Object Length -Sum).Sum / 1MB, 1)
        }
    } |
    ConvertTo-Csv -NoTypeInformation |
    Set-Content -Encoding UTF8 -Force $designOutput

Write-Host "Wrote $unityOutput"
Write-Host "Wrote $designOutput"
