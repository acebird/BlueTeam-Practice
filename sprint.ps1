#Add registry runkey
# Define the properties
$appName = "temp392058"
$exePath = "C:\Users\Public\c723561.exe"
$registryPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"

# Check for Administrative privileges
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "Elevated privileges required. Please run PowerShell as Administrator."
    return
}

# Add or update the registry key
try {
    New-ItemProperty -Path $registryPath -Name $appName -Value $exePath -PropertyType String -Force -ErrorAction Stop
    Write-Host "Success: '$appName' added to HKLM (All Users) startup." -ForegroundColor Green
} catch {
    Write-Error "Failed to write to registry: $($_.Exception.Message)"
}
