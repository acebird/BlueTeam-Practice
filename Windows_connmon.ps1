<#
.SYNOPSIS
    Windows System & Network Monitor (WinConnMon) - Fixed Version
    Resolved: 'Cannot overwrite variable pid' error.
#>

# Check for Admin Privileges
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "!!! WARNING: NOT RUNNING AS ADMIN. Binary paths and Services will be restricted. !!!" -ForegroundColor Red
    Start-Sleep -Seconds 2
}

# --- HELPER FUNCTIONS ---

function Get-DetailedProcessInfo($TargetID) {
    <# Renamed parameter from $pid to $TargetID to avoid reserved variable error #>
    if ($TargetID -eq 0) { return [PSCustomObject]@{ Name = "Idle"; Path = "N/A" } }
    if ($TargetID -eq 4) { return [PSCustomObject]@{ Name = "System"; Path = "C:\Windows\System32\ntoskrnl.exe" } }

    try {
        $proc = Get-Process -Id $TargetID -ErrorAction Stop
        # Try MainModule first (most accurate), then fallback to Path
        $path = "Access Denied"
        try { $path = $proc.MainModule.FileName } catch { $path = $proc.Path }
        if (-not $path) { $path = "Access Denied" }
        
        return [PSCustomObject]@{
            Name = $proc.ProcessName
            Path = $path
        }
    } catch {
        return [PSCustomObject]@{ Name = "Unknown/Exited"; Path = "N/A" }
    }
}

function Show-Menu {
    Clear-Host
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host " Windows Network & System Monitor        " -ForegroundColor Cyan
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "1. Active Connections (Established TCP)"
    Write-Host "2. TCP Listeners"
    Write-Host "3. UDP Listeners"
    Write-Host "4. User Sessions"
    Write-Host "5. Active Processes, Services & Binaries"
    Write-Host "Q. Quit"
    Write-Host "-----------------------------------------"
}

# --- VIEW LOGIC ---

function View-ActiveConnections {
    Write-Host "`n[ ACTIVE TCP CONNECTIONS ]`n" -ForegroundColor Yellow
    Get-NetTCPConnection -State Established -ErrorAction SilentlyContinue | ForEach-Object {
        $procId = $_.OwningProcess
        $info = Get-DetailedProcessInfo $procId
        [PSCustomObject]@{
            Local      = "$($_.LocalAddress):$($_.LocalPort)"
            Remote     = "$($_.RemoteAddress):$($_.RemotePort)"
            State      = $_.State
            PID        = $procId
            Process    = $info.Name
            BinaryPath = $info.Path
        }
    } | Format-Table -AutoSize
}

function View-TcpListeners {
    Write-Host "`n[ TCP LISTENERS ]`n" -ForegroundColor Yellow
    Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue | ForEach-Object {
        $procId = $_.OwningProcess
        $info = Get-DetailedProcessInfo $procId
        [PSCustomObject]@{
            ListenAddr = "$($_.LocalAddress):$($_.LocalPort)"
            PID        = $procId
            Process    = $info.Name
            BinaryPath = $info.Path
        }
    } | Format-Table -AutoSize
}

function View-UdpListeners {
    Write-Host "`n[ UDP LISTENERS ]`n" -ForegroundColor Yellow
    Get-NetUDPEndpoint -ErrorAction SilentlyContinue | ForEach-Object {
        $procId = $_.OwningProcess
        $info = Get-DetailedProcessInfo $procId
        [PSCustomObject]@{
            ListenAddr = "$($_.LocalAddress):$($_.LocalPort)"
            PID        = $procId
            Process    = $info.Name
            BinaryPath = $info.Path
        }
    } | Format-Table -AutoSize
}

function View-UserSessions {
    Write-Host "`n[ USER SESSIONS ]`n" -ForegroundColor Yellow
    # quser provides a snapshot of logged-in users and RDP sessions
    quser 2>$null
    if ($LASTEXITCODE -ne 0) { Write-Host "No active sessions found (or quser not available)." }
}

function View-ProcessesAndServices {
    Write-Host "`n[ ACTIVE PROCESSES & SERVICES ]`n" -ForegroundColor Yellow
    
    # Pre-map services to PIDs for speed
    $ServiceMap = @{}
    Get-CimInstance Win32_Service -Filter "State='Running'" | ForEach-Object {
        if (-not $ServiceMap.ContainsKey($_.ProcessId)) { $ServiceMap[$_.ProcessId] = @($_.Name) }
        else { $ServiceMap[$_.ProcessId] += $_.Name }
    }

    Get-Process | ForEach-Object {
        $currentId = $_.Id
        $info = Get-DetailedProcessInfo $currentId
        $services = ""
        if ($ServiceMap.ContainsKey($currentId)) { $services = ($ServiceMap[$currentId]) -join ', ' }

        [PSCustomObject]@{
            PID      = $currentId
            Process  = $_.ProcessName
            Services = $services
            Binary   = $info.Path
        }
    } | Sort-Object Process | Format-Table -AutoSize
}

# --- MAIN LOOP ---
while ($true) {
    Show-Menu
    $selection = Read-Host "Select a view (1-5, or Q)"
    Clear-Host
    switch ($selection) {
        '1' { View-ActiveConnections }
        '2' { View-TcpListeners }
        '3' { View-UdpListeners }
        '4' { View-UserSessions }
        '5' { View-ProcessesAndServices }
        'Q' { break }
        'q' { break }
        default { Write-Host "Invalid Selection." -ForegroundColor Red }
    }
    Write-Host "`nPress 'Enter' to return to menu..." -ForegroundColor Cyan
    $null = Read-Host
}
