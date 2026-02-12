$ShareFolder = "C:\Shares\Public"

#Stop SMB Service
Stop-Service -Name "LanmanServer" -Force
Set-Service -Name "LanmanServer" -StartupType Disabled

#Remove Permissions
if (Test-Path $ShareFolder) {
    Write-Host "[*] Removing all access and disabling inheritance on $ShareFolder..."
    $acl = Get-Acl $ShareFolder

    # Disable inheritance and remove inherited rules
    $acl.SetAccessRuleProtection($true, $false)

    # Remove all explicit rules
    $acl.Access | ForEach-Object { $acl.RemoveAccessRule($_) }

    # Apply ACL changes
    Set-Acl $ShareFolder $acl
} else {
    Write-Warning "[!] Folder $ShareFolder does not exist. Skipping ACL modification."
}

#Disable SMBv1 and SMBv2/3
Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force
Set-SmbServerConfiguration -EnableSMB2Protocol $false -Force

Get-NetAdapterBinding -Name "*" | Where-Object {$_.ComponentID -eq "ms_server"}
Get-NetAdapterBinding -Name "*" -ComponentID "ms_server" | Disable-NetAdapterBinding -PassThru
