param(
    [string[]] $Roots = @(),
    [string] $OutputPath = (Join-Path $PSScriptRoot "..\docs\inventory\local-drive-review-status.csv")
)

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
$resolvedOutput = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputPath)

function Get-ChildItemsSafely {
    param(
        [string] $Root,
        [switch] $FilesOnly,
        [string] $Filter = "*"
    )

    try {
        $params = @{
            LiteralPath = $Root
            Recurse = $true
            Force = $true
            ErrorAction = "SilentlyContinue"
            Filter = $Filter
        }

        if ($FilesOnly) {
            $params.File = $true
        }

        return @(Get-ChildItem @params)
    }
    catch {
        return @()
    }
}

Push-Location $repoRoot
try {
    $rows = [System.Collections.Generic.List[object]]::new()
    foreach ($root in $Roots) {
        $exists = Test-Path -LiteralPath $root
        $candidateItems = @()
        $projectVersionFiles = @()
        $topLevelEntries = @()
        $status = "missing"
        $notes = "Path does not exist."

        if ($exists) {
            try {
                $topLevelEntries = @(Get-ChildItem -LiteralPath $root -Force -ErrorAction Stop)
                $candidateItems = @(Get-ChildItemsSafely -Root $root | Where-Object {
                    $_.Name -match '(?i)21\s*verse|21verse'
                })
                $projectVersionFiles = @(Get-ChildItemsSafely -Root $root -FilesOnly -Filter "ProjectVersion.txt")
                $status = "reviewed"
                $notes = "Path was listable from this Windows session."
            }
            catch {
                $status = "blocked"
                $notes = $_.Exception.Message
            }
        }

        $rows.Add([PSCustomObject]@{
            root = $root
            status = $status
            top_level_entry_count = $topLevelEntries.Count
            candidate_21verse_name_count = $candidateItems.Count
            unity_project_marker_count = $projectVersionFiles.Count
            candidate_examples = (@($candidateItems | Select-Object -First 5 | ForEach-Object { $_.FullName }) -join "; ")
            unity_project_examples = (@($projectVersionFiles | Select-Object -First 5 | ForEach-Object { $_.FullName }) -join "; ")
            notes = $notes
        }) | Out-Null
    }

    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $resolvedOutput) | Out-Null
    if (Test-Path -LiteralPath $resolvedOutput) {
        $resolvedRoot = (Resolve-Path -LiteralPath $repoRoot).Path
        $existing = (Resolve-Path -LiteralPath $resolvedOutput).Path
        if (-not $existing.StartsWith($resolvedRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
            throw "Refusing to replace output outside repository: $existing"
        }

        Remove-Item -LiteralPath $existing -Force
    }

    $rows | Export-Csv -LiteralPath $resolvedOutput -NoTypeInformation
    Write-Output $resolvedOutput
}
finally {
    Pop-Location
}
