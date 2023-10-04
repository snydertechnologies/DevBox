<#
    .COMPONENT
    011-S-PriviledgedConfigurations

    .SYNOPSIS
    Configures priviledged settings for Windows Terminal, PowerShell, and other tools.

    .ROLE
    System / Administator
    
    .DESCRIPTION
    Tool used to automate the installation and setup of a Windows machines for development.

    .NOTES
    =====================================================================

    =====================================================================
#>

$remotePowershellConfigURL = "https://cdn.jsdelivr.net/gh/snydertechnologies/DevBox@master/windows/configs/powershell.config.json"

try {

    $powershellConfig = (New-Object System.Net.WebClient).DownloadString($remotePowershellConfigURL)
    $powershellConfigPath = [System.IO.Path]::GetTempFileName() + ".json"
    $powershellConfig | Out-File -FilePath $powershellConfigPath

}
catch {
    Write-Error "Failed to download $remotePowershellConfigURL"
    Read-Host "Press enter to continue..."
    return
}

Read-Host "Setup will fail if 010-S-ChocoWingetPackages isn't installed first. Press ENTER to acknowledge..."


# Define the path to the powershell.config.json file
$configPath = Join-Path -Path $PSHome -ChildPath "powershell.config.json"

# Ensure you're running this as an Administrator to write to $PSHome
if (-Not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "You must run this script as an Administrator!" -ForegroundColor Red
    exit 1
}

# Ensure the Windows Firewall is disabled, and other things that slow developers down
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 0
Set-MpPreference -DisableRealtimeMonitoring $true

# Write the JSON data to the powershell.config.json file
Move-Item -Force $powershellConfigPath $configPath

Write-Host "Configuration has been written to $configPath" -ForegroundColor Green

Write-Output "   "
Read-Host "Done. Press enter to exit..."
exit