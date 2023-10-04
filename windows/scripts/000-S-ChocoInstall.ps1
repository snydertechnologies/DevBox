<#
    .COMPONENT
    000-S-ChocoInstall

    .SYNOPSIS
    Downloads and installs Chocolatey.

    .ROLE
    System / Administator
    
    .DESCRIPTION
    Tool used to automate the installation and setup of a Windows machines for development.

    .NOTES
    =====================================================================
    # Reference: https://community.chocolatey.org/install.ps1
    =====================================================================
#>
Write-Host "Installing Chocolatey"
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

if (Get-Command choco -ErrorAction SilentlyContinu) {
    choco upgrade all -y
}

Write-Output "   "
Read-Host "Done. Press enter to exit..."
exit