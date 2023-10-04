<#
    .COMPONENT
    022-S-WinDockerPostSetup

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
Write-Output "Performing post-setup for Docker Desktop to work with WSL, after reboot has occured."
Read-Host "You have rebooted since installing Docker Desktop, right? Press ENTER to acknowledge..."

# Search for Docker Desktop.exe
$dockerDesktopPath = Get-ChildItem -Path "C:\Program Files\", "C:\Program Files (x86)\" -Recurse -Filter "Docker Desktop.exe" -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName

function Restart-DockerDesktop {
    param ()

    Write-Host "Restarting Docker Desktop to apply changes."
    # restart the docker service
    restart-service com.docker.service

    # If found, start it
    if ($dockerDesktopPath) {
        & "$dockerDesktopPath"
        Write-Output "Docker Desktop started from $dockerDesktopPath"
    } else {
        Write-Error "Docker Desktop.exe not found"
    }
}

# restart it
Restart-DockerDesktop


$remoteWslconfigURL = "https://cdn.jsdelivr.net/gh/snydertechnologies/DevBox@HEAD/windows/configs/.wslconfig"
try {
    $wslconfigContent = (New-Object System.Net.WebClient).DownloadString($remoteWslconfigURL)
    $wslconfigPath = [System.IO.Path]::GetTempFileName() + ".config"
    $wslconfigContent | Out-File -FilePath $wslconfigPath
}
catch {
    Write-Error "Failed to download $remoteWslconfigURL"
    Read-Host "Press enter to continue..."
    return
}
$wslDestination = "$env:USERPROFILE\.wslconfig"
if (Test-Path $wslDestination) {
    $overwrite = Read-Host "$wslDestination already exists. Overwrite? (y/n)"
    if ($overwrite -ne 'y') {
        Write-Host "Operation aborted by the user."
        return
    }
}
Move-Item -Force $wslconfigPath $wslDestination

$remoteDockerConfigURL = "https://cdn.jsdelivr.net/gh/snydertechnologies/DevBox@HEAD/windows/configs/docker.config.json"
try {
    $dockerConfigContent = (New-Object System.Net.WebClient).DownloadString($remoteDockerConfigURL)
    $dockerConfigPath = [System.IO.Path]::GetTempFileName() + ".json"
    $dockerConfigContent | Out-File -FilePath $dockerConfigPath
}
catch {
    Write-Error "Failed to download $remoteDockerConfigURL"
    Read-Host "Press enter to continue..."
    return
}
$dockerDestination = "$env:USERPROFILE\.docker\config.json"
if (Test-Path $dockerDestination) {
    $overwrite = Read-Host "$dockerDestination already exists. Overwrite? (y/n)"
    if ($overwrite -ne 'y') {
        Write-Host "Operation aborted by the user."
        return
    }
}
Move-Item -Force $dockerConfigPath $dockerDestination


Write-Host "Configuration applied. Shutting down WSL for changes to take effect."
wsl.exe --shutdown # stop
wsl.exe -d Ubuntu-22.04 uname -a # start by running a command

Restart-DockerDesktop

Write-Warning "You will need to reboot your computer for WSL to work properly."

Write-Output "   "
Read-Host "Done. Press enter to exit..."
exit