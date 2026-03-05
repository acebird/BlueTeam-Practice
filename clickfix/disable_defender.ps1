# Disable Microsoft Defender via registry for FLARE VM
# Run as Administrator

Write-Host "[*] Disabling Microsoft Defender policies..." -ForegroundColor Yellow

$defenderPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender"
$rtpPath = "$defenderPath\Real-Time Protection"
$spyNetPath = "$defenderPath\Spynet"

# Create required registry paths
New-Item -Path $defenderPath -Force | Out-Null
New-Item -Path $rtpPath -Force | Out-Null
New-Item -Path $spyNetPath -Force | Out-Null

# Disable Defender core
Set-ItemProperty -Path $defenderPath -Name "DisableAntiSpyware" -Type DWord -Value 1
Set-ItemProperty -Path $defenderPath -Name "DisableAntiVirus" -Type DWord -Value 1

# Disable Real-Time Protection features
Set-ItemProperty -Path $rtpPath -Name "DisableBehaviorMonitoring" -Type DWord -Value 1
Set-ItemProperty -Path $rtpPath -Name "DisableOnAccessProtection" -Type DWord -Value 1
Set-ItemProperty -Path $rtpPath -Name "DisableRealtimeMonitoring" -Type DWord -Value 1
Set-ItemProperty -Path $rtpPath -Name "DisableScanOnRealtimeEnable" -Type DWord -Value 1
Set-ItemProperty -Path $rtpPath -Name "DisableIOAVProtection" -Type DWord -Value 1

# Disable Defender cloud features
Set-ItemProperty -Path $spyNetPath -Name "SpyNetReporting" -Type DWord -Value 0
Set-ItemProperty -Path $spyNetPath -Name "SubmitSamplesConsent" -Type DWord -Value 2

# Disable Defender services if possible
Write-Host "[*] Attempting to stop Defender services..."

$services = @(
    "WinDefend",
    "WdNisSvc",
    "Sense"
)

foreach ($svc in $services) {
    Get-Service -Name $svc -ErrorAction SilentlyContinue | ForEach-Object {
        try {
            Stop-Service $_ -Force -ErrorAction SilentlyContinue
            Set-Service $_ -StartupType Disabled -ErrorAction SilentlyContinue
        } catch {}
    }
}

Write-Host "[+] Microsoft Defender policies applied."
Write-Host "[!] Reboot the VM for changes to fully apply." -ForegroundColor Green
