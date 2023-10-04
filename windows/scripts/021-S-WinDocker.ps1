<#
    .COMPONENT
    021-S-WinDocker

    .SYNOPSIS
    Installs Docker Desktop to work with WSL.

    .ROLE
    System / Administator
    
    .DESCRIPTION
    Tool used to automate the installation and setup of a Windows machines for development.

    .NOTES
    =====================================================================

    =====================================================================
#>
Write-Output "Installing and configuring Docker Desktop to work with WSL"
choco install docker-desktop -y

Write-Warning "You will need to reboot your computer AT THIS TIME for WSL to work properly."
Write-Warning "Move on to 022-S-WinDockerPostSetup after rebooting."

Write-Output "   "
Read-Host "Done. Press enter to exit..."
exit