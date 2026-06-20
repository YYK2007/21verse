param(
    [string] $ReferencePath = (Join-Path $PSScriptRoot "..\docs\inventory\unity-risky-asset-references.csv"),
    [string] $DispositionPath = (Join-Path $PSScriptRoot "..\docs\inventory\unity-asset-disposition.csv"),
    [string] $ExternalImportPath = (Join-Path $PSScriptRoot "..\docs\inventory\unity-external-imports.csv"),
    [string] $OutputPath = (Join-Path $PSScriptRoot "..\docs\inventory\unity-asset-replacement-worklist.csv")
)

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
$resolvedReference = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ReferencePath)
$resolvedDisposition = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($DispositionPath)
$resolvedExternalImport = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ExternalImportPath)
$resolvedOutput = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputPath)

Push-Location $repoRoot
try {
    $referenceRows = @(Import-Csv -LiteralPath $resolvedReference)
    $dispositionRows = @(Import-Csv -LiteralPath $resolvedDisposition)
    $externalRows = @(Import-Csv -LiteralPath $resolvedExternalImport)

    $dispositionsByFolder = @{}
    foreach ($row in $dispositionRows) {
        $dispositionsByFolder[$row.folder] = $row
    }

    $externalByFolder = @{}
    foreach ($row in $externalRows) {
        $externalByFolder[$row.folder] = $row
    }

    $workRows = [System.Collections.Generic.List[object]]::new()

    foreach ($row in $referenceRows) {
        $referencedFiles = @($row.referenced_by -split ';' |
            ForEach-Object { $_.Trim() } |
            Where-Object { -not [string]::IsNullOrWhiteSpace($_) })

        $disposition = $dispositionsByFolder[$row.folder]
        $external = $externalByFolder[$row.folder]
        $sourceType = if ($external) { $external.source_type } else { "unknown" }
        $action = if ($disposition) { $disposition.replacement_or_import_path } elseif ($external) { $external.import_or_replacement_path } else { "Review source and replacement path." }
        $validation = if ($disposition) { $disposition.validation_required } elseif ($external) { $external.validation_required } else { "Regenerate inventories and run Unity validation." }
        $issue = if ($disposition -and $disposition.issue) { $disposition.issue } elseif ($external) { $external.issue } else { "#2" }

        if ($referencedFiles.Count -eq 0) {
            $workRows.Add([PSCustomObject]@{
                folder = $row.folder
                referenced_file = ""
                file_kind = ""
                source_type = $sourceType
                release_decision = if ($disposition) { $disposition.release_decision } else { "pending" }
                recommended_action = $action
                validation_required = $validation
                issue = $issue
            }) | Out-Null
            continue
        }

        foreach ($referencedFile in $referencedFiles) {
            $extension = [System.IO.Path]::GetExtension($referencedFile).ToLowerInvariant()
            $fileKind = switch ($extension) {
                ".unity" { "scene" }
                ".prefab" { "prefab" }
                ".mat" { "material" }
                ".asset" { "asset" }
                default { "unity-serialized-file" }
            }

            $workRows.Add([PSCustomObject]@{
                folder = $row.folder
                referenced_file = $referencedFile
                file_kind = $fileKind
                source_type = $sourceType
                release_decision = if ($disposition) { $disposition.release_decision } else { "pending" }
                recommended_action = $action
                validation_required = $validation
                issue = $issue
            }) | Out-Null
        }
    }

    $outputDir = Split-Path -Parent $resolvedOutput
    New-Item -ItemType Directory -Force -Path $outputDir | Out-Null
    $workRows | Sort-Object folder, referenced_file | Export-Csv -LiteralPath $resolvedOutput -NoTypeInformation
    Write-Output $resolvedOutput
}
finally {
    Pop-Location
}
