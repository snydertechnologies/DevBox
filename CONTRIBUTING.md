# How To Contribute

## Setting Local Script Execution
```pwsh
# set this first
$WinSetupScript = @"
Set-ExecutionPolicy Bypass -Scope Process -Force
. '$PWD\windows\WinSetup.ps1'
"@
```
## Examples
```pwsh
# running against local scripts instead of remote
$env:SNYDER_WIN_SETUP_LOCAL = "true"; Invoke-Expression $WinSetupScript
```
```pwsh
# running a Non-Admin script
$env:SNYDER_WIN_SETUP = "010-U-NodePackages"; Invoke-Expression $WinSetupScript
```
```pwsh
# running an Admin script
$env:SNYDER_WIN_SETUP = "021-S-WinDocker"; Invoke-Expression $WinSetupScript
```
```pwsh
# using the prompt with remote scripts
Invoke-Expression $WinSetupScript

# using the prompt with local scripts
$env:SNYDER_WIN_SETUP_LOCAL = "true"; Invoke-Expression $WinSetupScript
```
```pwsh
# unsetting vars
Remove-Item Env:SNYDER_WIN_SETUP;
Remove-Item Env:SNYDER_WIN_SETUP_LOCAL;
```