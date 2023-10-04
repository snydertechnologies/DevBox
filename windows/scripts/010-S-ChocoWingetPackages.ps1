<#
    .COMPONENT
    010-S-ChocoWingetPackages

    .SYNOPSIS
    Installs useful utilities from Chocolatey + WinGet.

    .ROLE
    System / Administator
    
    .DESCRIPTION
    Tool used to automate the installation and setup of a Windows machines for development.

    .NOTES
    =====================================================================
    
    =====================================================================
#>
Write-Host "Installing useful utilities from Chocolatey + WinGet..."
choco install git.install --params "'/GitAndUnixToolsOnPath /WindowsTerminal /NoAutoCrlf'" -y
choco install powershell-core -y
choco install vscode --params "/NoDesktopIcon" -y
choco install jq -y
choco install make -y
choco install nvm.install -y
choco install rustup.install -y
choco install firacode -y
choco install starship -y
choco install visualstudio2022buildtools --package-parameters "--includeRecommended --add Microsoft.VisualStudio.Workload.CoreEditor --add Microsoft.VisualStudio.Workload.DataBuildTools --add Microsoft.VisualStudio.Workload.ManagedDesktopBuildTools --add Microsoft.VisualStudio.Workload.MSBuildTools --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Workload.WebBuildTools --add Microsoft.VisualStudio.Workload.XamarinBuildTools --passive --norestart --locale en-US --installWhileDownloading" -y
Write-Output "   "
Read-Host "Done. Press enter to exit..."
exit