
<#
    .COMPONENT
    030-U-FontsInstall

    .SYNOPSIS
    Installs Nerd Fonts on Windows.

    .ROLE
    User / Non-Administator
    
    .DESCRIPTION
    Tool used to automate the installation and setup of a Windows machines for development.

    .NOTES
    =====================================================================

    =====================================================================
#>
Write-Output "Installing Nerd Fonts on Windows"
Write-Output "   "
Write-Warning "You must run 010-U-TerminalSetup first."
Read-Host "Press ENTER to acknowledge..."

# change to the SnyderDev directory
Set-Location -Path $env:SNYDER_SNYDERDEV_PATH
$tmpSd = "$env:SNYDER_SNYDERDEV_PATH\_tmp"

if (-Not (Test-Path $tmpSd)) {
    New-Item -Path $tmpSd -ItemType Directory
}
Set-Location -Path $tmpSd

# clone
git clone https://github.com/powerline/fonts.git --depth=1
# install
cd fonts
pwsh -File ".\install.ps1"
# clean-up a bit
cd ..
# pnpx rimraf fonts

Write-Output "   "
Read-Host "Done. Press enter to exit..."
exit