<#
    .COMPONENT
    011-U-VSCodeSetup

    .SYNOPSIS
    Installs useful plugins for VS Code.

    .ROLE
    User / Non-Administator
    
    .DESCRIPTION
    Tool used to automate the installation and setup of a Windows machines for development.

    .NOTES
    =====================================================================
    
    =====================================================================
#>

Write-Information "Installing VS Code Plugins packages..."
code --install-extension ms-vscode-remote.remote-wsl
code --install-extension ms-dotnettools.csdevkit
code --install-extension ms-vscode-remote.remote-containers
code --install-extension ms-dotnettools.csharp
code --install-extension JannisX11.batch-rename-extension
code --install-extension matthewpi.caddyfile-support
code --install-extension naumovs.color-highlight
code --install-extension vivaxy.vscode-conventional-commits
code --install-extension ms-azuretools.vscode-dapr
code --install-extension denoland.vscode-deno
code --install-extension mikestead.dotenv
code --install-extension EditorConfig.EditorConfig
code --install-extension usernamehw.errorlens
code --install-extension dbaeumer.vscode-eslint
code --install-extension waderyan.gitblame
code --install-extension GitHub.copilot
code --install-extension eamodio.gitlens
code --install-extension golang.go
code --install-extension heybourn.headwind
code --install-extension VisualStudioExptTeam.vscodeintellicode
code --install-extension oderwat.indent-rainbow
code --install-extension ZainChen.json
code --install-extension ms-vscode.makefile-tools
code --install-extension ahmadalli.vscode-nginx-conf
code --install-extension christian-kohler.npm-intellisense
code --install-extension nrwl.angular-console
code --install-extension christian-kohler.path-intellisense
code --install-extension ms-vscode.powershell
code --install-extension yoavbls.pretty-ts-errors
code --install-extension ms-vscode-remote.remote-ssh
code --install-extension ms-vscode-remote.remote-ssh-edit
code --install-extension ms-vscode-remote.vscode-remote-extensionpack
code --install-extension ms-vscode-remote.remote-wsl
code --install-extension foxundermoon.shell-format
code --install-extension bradlc.vscode-tailwindcss
code --install-extension pflannery.vscode-versionlens

Write-Output "   "
Read-Host "Done. Press enter to exit..."
exit