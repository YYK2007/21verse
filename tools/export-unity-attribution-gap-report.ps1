param(
    [string] $PublicAssetManifestPath = (Join-Path $PSScriptRoot "..\docs\inventory\unity-public-asset-manifest.csv"),
    [string] $NoticePath = (Join-Path $PSScriptRoot "..\NOTICE.md"),
    [string] $CsvOutputPath = (Join-Path $PSScriptRoot "..\docs\inventory\unity-attribution-gap-report.csv"),
    [string] $MarkdownOutputPath = (Join-Path $PSScriptRoot "..\docs\unity-attribution-gap-report.md")
)

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
$resolvedCsvOutput = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($CsvOutputPath)
$resolvedMarkdownOutput = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($MarkdownOutputPath)

function Get-NoticeStatus {
    param(
        [object] $Row,
        [string] $NoticeText
    )

    if ($Row.folder -eq "Assets/TextMesh Pro") {
        return [PSCustomObject]@{
            notice_status = "pending_package_and_font_review"
            notice_required_before_public = "yes_if_any_textmesh_pro_or_liberation_sans_files_remain_bundled"
            recommended_notice_action = "Confirm Unity/TextMesh Pro redistribution terms and keep the LiberationSans OFL attribution if bundled font files remain."
        }
    }

    if ($Row.public_repo_treatment -eq "retain_candidate_reviewed") {
        return [PSCustomObject]@{
            notice_status = "project_scope_notice_complete"
            notice_required_before_public = "no_unless_non_original_material_is_added"
            recommended_notice_action = "No additional third-party NOTICE entry is required by the current folder-level audit; keep the NOTICE scope statement for 21Verse-developed project work."
        }
    }

    if ($Row.public_repo_treatment -match "exclude|replace") {
        return [PSCustomObject]@{
            notice_status = "defer_until_final_asset_decision"
            notice_required_before_public = "yes_if_retained_or_replaced_with_attribution_required_material"
            recommended_notice_action = "Do not add final NOTICE text yet; first remove, replace, import externally, or confirm redistribution rights for this folder."
        }
    }

    $folderName = Split-Path -Leaf $Row.folder
    $folderMentioned = $NoticeText -match [regex]::Escape($Row.folder) -or $NoticeText -match [regex]::Escape($folderName)
    if ($folderMentioned) {
        return [PSCustomObject]@{
            notice_status = "mentioned_but_owner_review_required"
            notice_required_before_public = "yes_if_non_original_material_remains"
            recommended_notice_action = "Keep the NOTICE entry only after final owner review confirms retained files are original or redistributable."
        }
    }

    return [PSCustomObject]@{
        notice_status = "owner_review_required_no_folder_notice"
        notice_required_before_public = "yes_if_non_original_material_remains"
        recommended_notice_action = "During final public review, add NOTICE/license attribution for any retained non-original files or document the folder as project-owned."
    }
}

Push-Location $repoRoot
try {
    $manifestRows = @(Import-Csv -LiteralPath $PublicAssetManifestPath)
    $noticeText = if (Test-Path -LiteralPath $NoticePath) {
        Get-Content -LiteralPath $NoticePath -Raw
    }
    else {
        ""
    }

    $rows = [System.Collections.Generic.List[object]]::new()
    foreach ($row in $manifestRows | Sort-Object folder) {
        $notice = Get-NoticeStatus -Row $row -NoticeText $noticeText
        $rows.Add([PSCustomObject]@{
            folder = $row.folder
            public_repo_treatment = $row.public_repo_treatment
            release_decision = $row.release_decision
            license_types = $row.license_types
            evidence_files = $row.evidence_files
            notice_status = $notice.notice_status
            notice_required_before_public = $notice.notice_required_before_public
            recommended_notice_action = $notice.recommended_notice_action
            issue = if ($row.public_repo_treatment -match "exclude|replace" -or $row.release_decision -eq "pending") { "#2" } else { "" }
        }) | Out-Null
    }

    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $resolvedCsvOutput) | Out-Null
    $rows | Export-Csv -LiteralPath $resolvedCsvOutput -NoTypeInformation

    $deferredRows = @($rows | Where-Object { $_.notice_status -eq "defer_until_final_asset_decision" })
    $ownerReviewRows = @($rows | Where-Object { $_.notice_status -eq "owner_review_required_no_folder_notice" })
    $packageRows = @($rows | Where-Object { $_.notice_status -eq "pending_package_and_font_review" })

    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add('# Unity Attribution Gap Report') | Out-Null
    $lines.Add('') | Out-Null
    $lines.Add('This report maps each Unity top-level asset folder to the NOTICE/attribution action required before any public release.') | Out-Null
    $lines.Add('') | Out-Null
    $lines.Add('Authoritative generated file:') | Out-Null
    $lines.Add('') | Out-Null
    $lines.Add('- `docs/inventory/unity-attribution-gap-report.csv`') | Out-Null
    $lines.Add('') | Out-Null
    $lines.Add('Refresh it after any Unity asset, disposition, or NOTICE change:') | Out-Null
    $lines.Add('') | Out-Null
    $lines.Add('```powershell') | Out-Null
    $lines.Add('.\tools\export-unity-attribution-gap-report.ps1') | Out-Null
    $lines.Add('```') | Out-Null
    $lines.Add("") | Out-Null
    $lines.Add("Summary: $($rows.Count) asset folders reviewed; $($deferredRows.Count) defer NOTICE text until final asset decision; $($ownerReviewRows.Count) retain candidates need owner review before final NOTICE clearance; $($packageRows.Count) package/font rows need package-specific review.") | Out-Null
    $lines.Add("") | Out-Null
    $lines.Add('This report does not grant redistribution rights. It records that the retained Unity folders currently need no additional third-party NOTICE entry beyond the 21Verse project-scope notice; any newly added third-party material must be reviewed separately.') | Out-Null
    $lines.Add('') | Out-Null
    $lines.Add('| Folder | Public treatment | Notice status | Required action |') | Out-Null
    $lines.Add('| --- | --- | --- | --- |') | Out-Null

    foreach ($row in $rows) {
        $action = ($row.recommended_notice_action -replace "\|", "/" -replace "`r?`n", " ").Trim()
        $lines.Add(("| ``{0}`` | ``{1}`` | ``{2}`` | {3} |" -f $row.folder, $row.public_repo_treatment, $row.notice_status, $action)) | Out-Null
    }

    Set-Content -LiteralPath $resolvedMarkdownOutput -Value $lines -Encoding UTF8
    Write-Output $resolvedCsvOutput
    Write-Output $resolvedMarkdownOutput
}
finally {
    Pop-Location
}
