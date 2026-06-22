param(
    [string] $HostName = "",
    [string] $Address = "",
    [string] $OutputPath = (Join-Path $PSScriptRoot "..\docs\inventory\nas-access-log.csv"),
    [string[]] $CandidateShares = @(
        "Public",
        "Shared",
        "Share",
        "21verse",
        "21Verse",
        "homes",
        "TimeMachineBackup",
        "SmartWare",
        "Backup"
    ),
    [int] $ShareProbeTimeoutSeconds = 8
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($HostName) -and [string]::IsNullOrWhiteSpace($Address)) {
    throw "Pass -HostName or -Address for the private archive you want to probe. Do not commit raw private host/IP evidence."
}

$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
$resolvedOutput = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputPath)

function New-Result {
    param(
        [string] $Check,
        [string] $Result
    )

    [PSCustomObject]@{
        check = $Check
        result = $Result
    }
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

function Invoke-ExternalCommand {
    param(
        [string] $FilePath,
        [string[]] $Arguments
    )

    $previousErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    try {
        $output = & $FilePath @Arguments 2>&1
        $exitCode = $LASTEXITCODE
    }
    finally {
        $ErrorActionPreference = $previousErrorActionPreference
    }

    return [PSCustomObject]@{
        ExitCode = $exitCode
        Output = @($output | ForEach-Object { $_.ToString().Trim() } | Where-Object { $_ })
    }
}

function Test-ShareRoot {
    param(
        [string] $Path,
        [int] $TimeoutSeconds
    )

    $job = Start-Job -ScriptBlock {
        param([string] $ProbePath)

        Get-ChildItem -LiteralPath $ProbePath -ErrorAction Stop |
            Select-Object -First 5 -ExpandProperty Name
    } -ArgumentList $Path

    try {
        $completed = Wait-Job -Job $job -Timeout $TimeoutSeconds
        if (-not $completed) {
            Stop-Job -Job $job | Out-Null
            return [PSCustomObject]@{
                Listed = $false
                Message = "timed out after $TimeoutSeconds seconds"
            }
        }

        $items = @(Receive-Job -Job $job -ErrorAction Stop)
        return [PSCustomObject]@{
            Listed = $true
            Message = "listed $($items.Count) entries: " + ($items -join "; ")
        }
    }
    catch {
        return [PSCustomObject]@{
            Listed = $false
            Message = "not listable: " + (($_.Exception.Message -replace "\s+", " ").Trim())
        }
    }
    finally {
        Remove-Job -Job $job -Force -ErrorAction SilentlyContinue
    }
}

Push-Location $repoRoot
try {
    $rows = [System.Collections.Generic.List[object]]::new()
    $probeTargets = @()
    if (-not [string]::IsNullOrWhiteSpace($Address)) {
        $probeTargets += $Address
    }
    if (-not [string]::IsNullOrWhiteSpace($HostName)) {
        $probeTargets += $HostName
    }

    $smbMappings = @(Get-SmbMapping -ErrorAction SilentlyContinue |
        Where-Object {
            (-not [string]::IsNullOrWhiteSpace($HostName) -and $_.RemotePath -match [regex]::Escape($HostName)) -or
            (-not [string]::IsNullOrWhiteSpace($Address) -and $_.RemotePath -match [regex]::Escape($Address))
        })

    $rows.Add((New-Result "Get-SmbMapping" ($(if ($smbMappings.Count -gt 0) { ($smbMappings | ForEach-Object { "$($_.LocalPath) -> $($_.RemotePath) [$($_.Status)]" }) -join "; " } else { "no active mapping for requested private archive" })))) | Out-Null

    $netUse = Invoke-ExternalCommand "net.exe" @("use")
    $activeNetUse = @($netUse.Output | Where-Object {
        (-not [string]::IsNullOrWhiteSpace($HostName) -and $_ -match [regex]::Escape($HostName)) -or
        (-not [string]::IsNullOrWhiteSpace($Address) -and $_ -match [regex]::Escape($Address))
    })
    $rows.Add((New-Result "net use" ($(if ($activeNetUse.Count -gt 0) { $activeNetUse -join "; " } else { "no active connection" })))) | Out-Null

    if (-not [string]::IsNullOrWhiteSpace($Address)) {
        $ping = Test-Connection -ComputerName $Address -Count 1 -Quiet
        $rows.Add((New-Result "ICMP ping" ($(if ($ping) { "address reachable" } else { "address did not respond to one ICMP ping" })))) | Out-Null

        $nbtstat = Invoke-ExternalCommand "nbtstat.exe" @("-A", $Address)
        $netbiosNames = @($nbtstat.Output | Where-Object { $_ -match "<(00|03|20)>" } | ForEach-Object { ($_ -replace "\s+", " ").Trim() })
        $rows.Add((New-Result "NetBIOS" ($(if ($netbiosNames.Count -gt 0) { "NetBIOS names returned; raw names omitted from public-safe summaries" } else { "no NetBIOS names returned" })))) | Out-Null
    }

    $openPorts = [System.Collections.Generic.List[string]]::new()
    $closedPorts = [System.Collections.Generic.List[string]]::new()
    $ports = @(
        [PSCustomObject]@{ Number = 22; Label = "SSH" }
        [PSCustomObject]@{ Number = 80; Label = "HTTP" }
        [PSCustomObject]@{ Number = 139; Label = "NetBIOS session" }
        [PSCustomObject]@{ Number = 445; Label = "SMB" }
        [PSCustomObject]@{ Number = 443; Label = "HTTPS" }
        [PSCustomObject]@{ Number = 548; Label = "AFP" }
        [PSCustomObject]@{ Number = 2049; Label = "NFS" }
    )

    foreach ($port in $ports) {
        if ([string]::IsNullOrWhiteSpace($Address)) {
            continue
        }

        $connection = Test-NetConnection -ComputerName $Address -Port $port.Number -WarningAction SilentlyContinue
        if ($connection.TcpTestSucceeded) {
            $openPorts.Add("$($port.Number) $($port.Label)") | Out-Null
        }
        else {
            $closedPorts.Add("$($port.Number) $($port.Label)") | Out-Null
        }
    }

    $rows.Add((New-Result "Open TCP ports" ($(if ($openPorts.Count -gt 0) { $openPorts -join "; " } else { "none detected" })))) | Out-Null
    $rows.Add((New-Result "Closed TCP ports" ($(if ($closedPorts.Count -gt 0) { $closedPorts -join "; " } else { "none detected" })))) | Out-Null

    foreach ($targetHost in $probeTargets) {
        $target = "\\$targetHost"
        try {
            $items = @(Get-ChildItem -LiteralPath $target -ErrorAction Stop | Select-Object -First 5)
            $rows.Add((New-Result "UNC root $target" ("listed $($items.Count) entries: " + (($items | ForEach-Object { $_.Name }) -join "; ")))) | Out-Null
        }
        catch {
            $message = ($_.Exception.Message -replace "\s+", " ").Trim()
            $rows.Add((New-Result "UNC root $target" "not listable: $message")) | Out-Null
        }
    }

    foreach ($targetHost in $probeTargets) {
        $target = "\\$targetHost"
        $viewTarget = $target.TrimEnd("\")
        $view = Invoke-ExternalCommand "net.exe" @("view", $viewTarget)
        if ($view.ExitCode -eq 0) {
            $rows.Add((New-Result "net view $viewTarget" (($view.Output | Select-Object -First 8) -join "; "))) | Out-Null
        }
        else {
            $summary = (($view.Output | Where-Object { $_ -match "System error|Access is denied|network path|password|The command completed" } | Select-Object -First 4) -join "; ")
            if ([string]::IsNullOrWhiteSpace($summary)) {
                $summary = "failed with exit code $($view.ExitCode)"
            }
            $rows.Add((New-Result "net view $viewTarget" $summary)) | Out-Null
        }
    }

    $uniqueCandidateShares = @($CandidateShares |
        Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
        ForEach-Object { $_.Trim() } |
        Select-Object -Unique)

    foreach ($targetHost in $probeTargets) {
        foreach ($share in $uniqueCandidateShares) {
            $sharePath = "\\$targetHost\$share"
            $shareResult = Test-ShareRoot -Path $sharePath -TimeoutSeconds $ShareProbeTimeoutSeconds
            $rows.Add((New-Result "UNC share $sharePath" $shareResult.Message)) | Out-Null
        }
    }

    $webStatus = "not checked"
    if (-not [string]::IsNullOrWhiteSpace($Address)) {
        try {
            $response = Invoke-WebRequest -UseBasicParsing -Uri "http://$Address/" -TimeoutSec 10
            $webStatus = "HTTP $($response.StatusCode) at root"
        }
        catch {
            $webStatus = "HTTP probe failed: " + (($_.Exception.Message -replace "\s+", " ").Trim())
        }
    }
    $rows.Add((New-Result "WD web UI" $webStatus)) | Out-Null

    $outputDir = Split-Path -Parent $resolvedOutput
    New-Item -ItemType Directory -Force -Path $outputDir | Out-Null
    $tempPath = Join-Path $env:TEMP ("nas-access-log-" + [guid]::NewGuid().ToString("N") + ".csv")
    $rows | Export-Csv -LiteralPath $tempPath -NoTypeInformation
    try {
        Replace-GeneratedFile -SourcePath $tempPath -DestinationPath $resolvedOutput
        Write-Output $resolvedOutput
    }
    catch {
        Write-Warning "Could not replace $resolvedOutput. Probe output was left at $tempPath. Error: $($_.Exception.Message)"
        Write-Output $tempPath
    }
}
finally {
    Pop-Location
}
