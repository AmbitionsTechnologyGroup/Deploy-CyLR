#requires -RunAsAdministrator

# Set variables
Write-Host -NoNewline "`n [*] Setting up working folders, paths, and URLs...  "
$date = Get-Date -Format "MM-dd-yyyy_HH-mm-ss"
$workingDir = "$env:SYSTEMDRIVE\CyLR"
$cylrExe = "$workingDir\CyLR.exe"
$cylrOutputFileName = "CyLR-$env:COMPUTERNAME-$date.zip"
$cylrUri = "http://download.ambitionsgroup.com/Software/CyLR.exe"
$netClient = New-Object System.Net.WebClient
Write-Host "Done!"

$zipPassword = ""
$sftpServerIp = ""
$sftpUserName = ""
$sftpPassword = ""

# Create working directory, download CyLR
Write-Host -NoNewline " [*] Creating working directory and downloading tools...  "
New-Item -ItemType Directory -Force -Path $workingDir | Out-Null
Write-Host "Done!`n"

Write-Host -NoNewline " --> Downloading CyLR executable...  "
$netClient.DownloadFile($cylrUri, $cylrExe)
Write-Host "Done!"

# Run CyLR with default collection parameters; upload to ATG SFTP server
Write-Host " --> Running CyLR with default collection parameters"
Write-Host "  ########### BEGIN CYLR ###########`n"

$cylrArgs = "-of", "$cylrOutputFileName", `
            "-os", "/upload", `
            "-zl", "7", `
            "--usnjrnl", `
            "-zp", "$zipPassword", `
            "-u", "$sftpUserName", `
            "-p", "$sftpPassword", `
            "-s", "$sftpServerIp"

Start-Process -Wait -NoNewWindow -WorkingDirectory $workingDir "$cylrExe" -ArgumentList "$cylrArgs"
Write-Host " ########### END CYLR ###########`n"
Write-Host -NoNewLine " [*] Removing working directory and files...  "
Remove-Item -Recurse -Force -Path $workingDir
Write-Host "Done!`n"
Write-Host "Collection Complete!`n"
