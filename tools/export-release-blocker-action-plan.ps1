param(
    [string] $RequirementsPath = (Join-Path $PSScriptRoot "..\docs\inventory\release-requirements-status.csv"),
    [string] $OutputPath = (Join-Path $PSScriptRoot "..\docs\inventory\release-blocker-action-plan.csv")
)

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
$resolvedOutput = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputPath)

function Get-BlockerDetail {
    param(
        [string] $Requirement,
        [string] $Issue
    )

    switch -Regex ($Requirement) {
        "NAS" {
            return [PSCustomObject]@{
                OwnerAction = "Mount or authenticate to the private archive outside the repository, then run tools/export-nas-inventory.ps1 against the mounted share without committing raw private evidence."
                LocalNextCommand = ".\tools\test-nas-access.ps1"
                CompletionEvidence = "docs/inventory/nas-review-status.csv has all rows complete and docs/inventory/generated/nas-candidate-files.csv has been reviewed for public-safe additions."
                ExternalDependency = "NAS share path and/or SMB credentials."
            }
        }
        "smoke" {
            return [PSCustomObject]@{
                OwnerAction = "Open unity/21verse-vr-game-hub in Unity 2022.3.25f1, use docs/inventory/unity-interactive-smoke-plan.csv, and mark interactive results complete."
                LocalNextCommand = ".\tools\export-unity-pre-smoke-status.ps1; .\tools\export-unity-interactive-smoke-plan.ps1; .\tools\run-unity-scene-validation.ps1"
                CompletionEvidence = "docs/inventory/unity-smoke-test-status.csv has all rows complete and issue #3 records interactive Unity/VR results."
                ExternalDependency = "Interactive Unity editor/VR smoke-test session."
            }
        }
        "third-party asset" {
            return [PSCustomObject]@{
                OwnerAction = "Resolve each pending Unity asset disposition by confirming redistribution rights, replacing assets, or documenting external import/removal steps."
                LocalNextCommand = ".\tools\export-unity-asset-replacement-worklist.ps1; .\tools\export-public-asset-manifest.ps1; .\tools\export-public-release-file-plan.ps1"
                CompletionEvidence = "docs/inventory/unity-asset-disposition.csv has no pending rows, NOTICE/README reflect retained assets, and Unity validation still passes."
                ExternalDependency = "Asset ownership/license decisions and Unity replacement/import work."
            }
        }
        "branch protection" {
            return [PSCustomObject]@{
                OwnerAction = "Run branch protection apply/verification from a GitHub admin session without changing repo visibility."
                LocalNextCommand = ".\tools\set-github-branch-protection.ps1; .\tools\set-github-branch-protection.ps1 -Apply; .\tools\test-github-branch-protection.ps1"
                CompletionEvidence = "docs/inventory/github-branch-protection-status.csv has all rows complete."
                ExternalDependency = "GitHub credential with admin access to YYK2007/21verse."
            }
        }
        default {
            return [PSCustomObject]@{
                OwnerAction = "Review linked evidence and update the requirement row."
                LocalNextCommand = ".\tools\run-release-audit.ps1"
                CompletionEvidence = "Requirement status is complete or deliberately documented as excluded."
                ExternalDependency = "Manual review."
            }
        }
    }
}

Push-Location $repoRoot
try {
    $requirementRows = @(Import-Csv -LiteralPath $RequirementsPath)
    $blockedRows = @($requirementRows | Where-Object { $_.status -eq "blocked" })

    $rows = foreach ($row in $blockedRows) {
        $detail = Get-BlockerDetail -Requirement $row.requirement -Issue $row.issue
        [PSCustomObject]@{
            requirement = $row.requirement
            issue = $row.issue
            current_status = $row.status
            evidence = $row.evidence
            owner_action = $detail.OwnerAction
            local_next_command = $detail.LocalNextCommand
            completion_evidence = $detail.CompletionEvidence
            external_dependency = $detail.ExternalDependency
        }
    }

    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $resolvedOutput) | Out-Null
    $rows | Export-Csv -LiteralPath $resolvedOutput -NoTypeInformation
    Write-Output $resolvedOutput
}
finally {
    Pop-Location
}
