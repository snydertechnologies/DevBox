<#
    .COMPONENT
    010-U-NodePackages

    .SYNOPSIS
    Installs NodeJS Latest Version + Globals as a Non-Administrator.

    .ROLE
    User / Non-Administator
    
    .DESCRIPTION
    Tool used to automate the installation and setup of a Windows machines for development.

    .NOTES
    =====================================================================
    We use NVM to install NodeJS. NVM is a version manager for NodeJS.
    We intentionally do not install as an Administrator because we want
    The user to be able to install and manage their own NodeJS versions
    Without needing to be an Administrator.
    =====================================================================
#>
Write-Output "Installing NodeJS Latest Version + Globals as a Non-Administrator."
Write-Output "   "

Write-Warning "You may get Admin prompt approvals... press Enter..."
Write-Output "   "

nvm install v20
nvm use v20
npm -g install pnpm yarn npm env-cmd nx pm2 prettier dotenv-cli dotenv-expand

Write-Output "   "
Read-Host "Done. Press enter to exit..."
exit