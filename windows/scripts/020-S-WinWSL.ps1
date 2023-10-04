<#
    .COMPONENT
    020-S-WinWSL

    .SYNOPSIS
    Installs WSL with Ubuntu 22.04.

    .ROLE
    System / Administator
    
    .DESCRIPTION
    Tool used to automate the installation and setup of a Windows machines for development.

    .NOTES
    =====================================================================

    =====================================================================
#>
Write-Output "Installing WSL..."
Write-Output "   "

dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

Write-Output "  "
Write-Output "Installing Ubuntu 22.04..."
wsl.exe --install -d Ubuntu-22.04
wsl.exe --set-default-version 2
wsl.exe --setdefault Ubuntu-22.04

Write-Warning "You will need to reboot your computer for WSL to work properly."

Write-Output "   "
Read-Host "Done. Press enter to exit..."
exit