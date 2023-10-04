
<#
    .COMPONENT
    030-S-DaprSetup

    .SYNOPSIS
    Installs Dapr on Windows.

    .ROLE
    System / Administator
    
    .DESCRIPTION
    Tool used to automate the installation and setup of a Windows machines for development.

    .NOTES
    =====================================================================

    =====================================================================
#>
Write-Output "Installing Nerd Fonts on Windows"
Write-Output "   "
Write-Warning "You must run 021-S-WinDocker first, and must have rebooted."
Read-Host "Press ENTER to acknowledge..."

pwsh.exe -Command "iwr -useb https://cdn.jsdelivr.net/gh/dapr/cli@HEAD/install/install.ps1 | iex"
refreshenv

if (Get-Command dapr -ErrorAction SilentlyContinu) {
    dapr uninstall --all
    dapr init
}

Write-Output "   "
Read-Host "Done. Press enter to exit..."
exit