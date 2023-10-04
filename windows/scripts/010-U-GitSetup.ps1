<#
    .COMPONENT
    010-U-GitSetup

    .SYNOPSIS
    Configures git settings for the current user.

    .ROLE
    User / Non-Administator
    
    .DESCRIPTION
    Tool used to automate the installation and setup of a Windows machines for development.

    .NOTES
    =====================================================================
    
    =====================================================================
#>

iex (iwr -UseBasicParsing 'https://cdn.jsdelivr.net/gh/snydertechnologies/DevBox@HEAD/shared/scripts/GitConfigSetup.ps1').Content

Write-Output "   "
Read-Host "Done. Press enter to exit..."
exit