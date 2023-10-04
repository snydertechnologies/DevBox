
# Provisioning Scripts for a Windows 11 DevBox
Run one of the following. Store this in your Powershell session. Can be legacy Powershell before PS Core.
```pwsh
# jsDelivr cached version
$WinSetupScript = @"
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://cdn.jsdelivr.net/gh/snydertechnologies/DevBox@master/windows/WinSetup.ps1'))
"@
```
```pwsh
# github raw version
$WinSetupScript = @"
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/snydertechnologies/DevBox/master/windows/WinSetup.ps1'))
"@
```
### Get A Prompt
```pwsh
# Run without setting $env:SNYDER_WIN_SETUP
# This will cause you to be prompted for each step
Invoke-Expression $WinSetupScript
``````
### Or Run A Specific Step
| Pattern         | Meaning     |
|--------------|-----------|
| `XXX-`      | Priority; Lowest = First  |
|  `S-` | System / Administrator      |
| `U-`      | User / Non-Administrator  |

```pwsh
$env:SNYDER_WIN_SETUP = "000-S-ChocoInstall"; Invoke-Expression $WinSetupScript # install chocolatey
$env:SNYDER_WIN_SETUP = "000-S-MicrosoftStore"; Invoke-Expression $WinSetupScript # update Microsoft Store
$env:SNYDER_WIN_SETUP = "010-S-ChocoWingetPackages"; Invoke-Expression $WinSetupScript # install stuff as admin
$env:SNYDER_WIN_SETUP = "010-U-ChocoWingetPackages"; Invoke-Expression $WinSetupScript # install stuff as non-admin
$env:SNYDER_WIN_SETUP = "010-U-GitSetup"; Invoke-Expression $WinSetupScript # configure your git
$env:SNYDER_WIN_SETUP = "010-U-NodePackages"; Invoke-Expression $WinSetupScript #  install NVM and latest NodeJS and globals
$env:SNYDER_WIN_SETUP = "010-U-TerminalSetup"; Invoke-Expression $WinSetupScript # configure Windows Terminal
$env:SNYDER_WIN_SETUP = "011-S-PriviledgedConfigurations"; Invoke-Expression $WinSetupScript # configure priviledges settings
$env:SNYDER_WIN_SETUP = "011-U-VSCodeSetup"; Invoke-Expression $WinSetupScript # install VSC plugins
$env:SNYDER_WIN_SETUP = "020-S-WinWSL"; Invoke-Expression $WinSetupScript # install WSL with Ubuntu 22.04
$env:SNYDER_WIN_SETUP = "021-S-WinDocker"; Invoke-Expression $WinSetupScript # install Docker with WSL compat
$env:SNYDER_WIN_SETUP = "022-S-WinDockerPostSetup"; Invoke-Expression $WinSetupScript # Post-setup of docker Docker with WSL compat
$env:SNYDER_WIN_SETUP = "030-S-DaprSetup"; Invoke-Expression $WinSetupScript # install and configure Dapr on Windows
$env:SNYDER_WIN_SETUP = "030-U-FontsInstall"; Invoke-Expression $WinSetupScript # installs fonts on Windows
```

# WSL Setup
Run one of the following:
```zsh
## cached script
sudo apt install zsh -y && curl -fsSL https://cdn.jsdelivr.net/gh/snydertechnologies/DevBox@HEAD/wsl/WslSetup.zsh | zsh
```
```zsh
## not cached
sudo apt install zsh -y && curl -fsSL https://raw.githubusercontent.com/snydertechnologies/DevBox/HEAD/wsl/WslSetup.zsh | zsh
```

### Then you can run these to install additional stuff
```zsh
# 000-S-InitSetup  (this was already done during WslSetup)
wget https://cdn.jsdelivr.net/gh/snydertechnologies/DevBox@HEAD/wsl/scripts/000-S-InitSetup.zsh -O /tmp/x.zsh && chmod +x /tmp/x.zsh && zsh /tmp/x.zsh
```
```zsh
# 001-S-CoreUtilitiesInstall 
wget https://cdn.jsdelivr.net/gh/snydertechnologies/DevBox@HEAD/wsl/scripts/001-S-CoreUtilitiesInstall.zsh -O /tmp/x.zsh && chmod +x /tmp/x.zsh && zsh /tmp/x.zsh
```
```zsh
# 002-U-GitSetup 
wget https://cdn.jsdelivr.net/gh/snydertechnologies/DevBox@HEAD/wsl/scripts/002-U-GitSetup.zsh -O /tmp/x.zsh && chmod +x /tmp/x.zsh && zsh /tmp/x.zsh
```
