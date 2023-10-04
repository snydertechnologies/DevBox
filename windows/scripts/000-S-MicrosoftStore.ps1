<#
    .COMPONENT
    000-S-MicrosoftStore

    .SYNOPSIS
    Updates the Microsoft Store and all installed apps.

    .ROLE
    System / Administator
    
    .DESCRIPTION
    Tool used to automate updates to the Microsoft Store and all installed apps.

    .NOTES
    =====================================================================
    
    =====================================================================
#>
Write-Host "Updating the Microsoft Store..."
Get-CimInstance -Namespace "Root\cimv2\mdm\dmmap" -ClassName "MDM_EnterpriseModernAppManagement_AppManagement01" | Invoke-CimMethod -MethodName UpdateScanMethod
Write-Output "   "
Read-Host "Done. Press enter to exit..."
exit