<#
    .COMPONENT
    010-U-TerminalSetup

    .SYNOPSIS
    Configures the Windows Terminal for the current user.

    .ROLE
    User / Non-Administator
    
    .DESCRIPTION
    Tool used to automate the installation and setup of a Windows machines for development.

    .NOTES
    =====================================================================

    =====================================================================
#>

$remoteWinTermSettingsURL = "https://cdn.jsdelivr.net/gh/snydertechnologies/DevBox@master/windows/configs/windows-terminal-settings.json"
$remotePowershellProfile = "https://cdn.jsdelivr.net/gh/snydertechnologies/DevBox@master/windows/configs/Microsoft.PowerShell_profile.ps1"
$remoteStarshipConfig = "https://cdn.jsdelivr.net/gh/snydertechnologies/DevBox@master/windows/configs/starship.toml"

try {

    $winTermSettings = (New-Object System.Net.WebClient).DownloadString($remoteWinTermSettingsURL)
    $winTermSettingsPath = [System.IO.Path]::GetTempFileName() + ".json"
    $winTermSettings | Out-File -FilePath $winTermSettingsPath

}
catch {
    Write-Error "Failed to download $remoteWinTermSettingsURL"
    Read-Host "Press enter to continue..."
    return
}

try {

    $powershellProfile = (New-Object System.Net.WebClient).DownloadString($remotePowershellProfile)
    $powershellProfilePath = [System.IO.Path]::GetTempFileName() + ".ps1"
    $powershellProfile | Out-File -FilePath $powershellProfilePath

}
catch {
    Write-Error "Failed to download $remotePowershellProfile"
    Read-Host "Press enter to continue..."
    return
}

try {

    $starshipConfig= (New-Object System.Net.WebClient).DownloadString($remoteStarshipConfig)
    $starshipConfigPath = [System.IO.Path]::GetTempFileName() + ".toml"
    $starshipConfig | Out-File -FilePath $starshipConfigPath

}
catch {
    Write-Error "Failed to download $remoteStarshipConfig"
    Read-Host "Press enter to continue..."
    return
}

Read-Host "Setup will fail if 010-S-ChocoWingetPackages isn't installed first. Press ENTER to acknowledge..."

# update Windows Terminal 
jq -S -s '.[0] * .[1]' $winTermSettingsPath "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" > temp-winTermSettings.json
Move-Item -Force temp-winTermSettings.json "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

# Determine if the $PROFILE exists
if (-Not (Test-Path $PROFILE)) {
    # Create the $PROFILE
    New-Item -Path $PROFILE -ItemType File -Force
    Write-Host "$PROFILE has been created." -ForegroundColor Green
} else {
    Write-Host "$PROFILE already exists." -ForegroundColor Yellow
}

# Move the custom PowerShell profile to the $PROFILE location
Move-Item -Force $powershellProfilePath $PROFILE
Write-Host "Profile script has been moved to $PROFILE." -ForegroundColor Green

$finalStarshipConfigPath = "$HOME\.config\starship.toml"
$starshipConfigPath
if (-Not (Test-Path $finalStarshipConfigPath)) {
    New-Item -Path $finalStarshipConfigPath -ItemType File -Force
}
if ($null -ne $starshipConfigPath -and (Test-Path $starshipConfigPath)) {
    Move-Item -Force $starshipConfigPath $finalStarshipConfigPath
    Write-Host "Starship config has been installed to $finalStarshipConfigPath." -ForegroundColor Green
} else {
    Write-Host "The source profile script path is invalid or does not exist." -ForegroundColor Red
}

Write-Output "   "
Read-Host "Done. Press enter to exit..."
exit