# STWinSetup.ps1

# Check if the script is running as Administrator
function Test-IsAdmin {
    return ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Exit if the script is running as an Administrator
if (Test-IsAdmin) {
    Write-Host "You must exit this script as a Non-Administrator. Exiting ..." -ForegroundColor Red
    exit 1
}

if ($env:SNYDER_WIN_SETUP_LOCAL -eq 'true') {
    $useLocalScripts = $true
    $localScriptsPath = "$PSScriptRoot\scripts\"
} else {
    $useLocalScripts = $false
    $localScriptsPath = $null
}

$dirPath = "$HOME\Downloads\WinSetup"
if (-not (Test-Path $dirPath)) {
    New-Item -Path $dirPath -ItemType Directory
}
Write-Information "Scripts will be executed within: $dirPath"

$scriptExecutionList = @(
    @{ Name = "000-S-ChocoInstall"; NeedsElevation = $true; ExecShell = "powershell" },
    @{ Name = "000-S-MicrosoftStore"; NeedsElevation = $true; ExecShell = "powershell" },
    @{ Name = "010-S-ChocoWingetPackages"; NeedsElevation = $true; ExecShell = "powershell" },
    @{ Name = "010-U-ChocoWingetPackages"; NeedsElevation = $false; ExecShell = "powershell" },
    @{ Name = "010-U-GitSetup"; NeedsElevation = $false; ExecShell = "pwsh" },
    @{ Name = "010-U-NodePackages"; NeedsElevation = $false; ExecShell = "powershell" },
    @{ Name = "010-U-TerminalSetup"; NeedsElevation = $false; ExecShell = "pwsh" },
    @{ Name = "011-S-PriviledgedConfigurations"; NeedsElevation = $true; ExecShell = "pwsh" },
    @{ Name = "011-U-VSCodeSetup"; NeedsElevation = $false; ExecShell = "pwsh" },
    @{ Name = "020-S-WinWSL"; NeedsElevation = $true; ExecShell = "pwsh" },
    @{ Name = "021-S-WinDocker"; NeedsElevation = $true; ExecShell = "pwsh" },
    @{ Name = "022-S-WinDockerPostSetup"; NeedsElevation = $true; ExecShell = "pwsh" },
    @{ Name = "030-S-DaprSetup"; NeedsElevation = $true; ExecShell = "pwsh" },
    @{ Name = "030-U-FontsInstall"; NeedsElevation = $false; ExecShell = "pwsh" }
)
$scriptExecutionList = $scriptExecutionList | ForEach-Object { [hashtable]$_ }

$scriptInstallers = $scriptExecutionList | ForEach-Object { $_.Name }

# Get the environment variable
$setupType = $env:SNYDER_WIN_SETUP

# Check if $setupType is not defined
if (-not $setupType) {

    Write-Information "No setup type defined. Prompting for setup type ..."
    $options = $scriptInstallers
    $choice = $options | Out-GridView -Title "Choose a setup type" -OutputMode Single
    Write-Information "Selected setup type: $choice"
    # Optionally set the environment variable for subsequent sessions
    $env:SNYDER_WIN_SETUP_PROMPT = $choice
}

# Check conditions and assign value if true
if ($null -eq $setupType -and [string]::IsNullOrWhiteSpace($env:SNYDER_WIN_SETUP_PROMPT) -eq $false) {
    $setupType = $env:SNYDER_WIN_SETUP_PROMPT
}

function Execute-SpecificScript {
    param (
        [string]$scriptName
    )

    $scriptToExecute = $scriptExecutionList | Where-Object { $_.Name -eq $scriptName }

    if ($null -eq $scriptToExecute) {
        Write-Host "Script [$scriptName] not found!"
    }
    else {
        Execute-Block -scriptInstallerName $scriptToExecute.Name -execShell $scriptToExecute.ExecShell -needsElevation $scriptToExecute.NeedsElevation
    }
}

function Show-Footer {
    $footer = @"

Thanks for using STWinSetup! 

Please check $dirPath\StWinSetup.log for log details.

Press any key to exit.
"@
    Write-Output $footer
    $null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Execute-Block {
    param (
        [string]$scriptInstallerName,
        [string]$execShell,
        [bool]$needsElevation
    )

    Write-Output "Executing script: $scriptInstallerName with elevation: $needsElevation"
    $logFilePath = Join-Path -Path $dirPath -ChildPath "StWinSetup.log"

    # Execute the script based on the $env:SNYDER_WIN_SETUP_LOCAL flag
    if ($useLocalScripts) {
        $scriptPath = Join-Path -Path $localScriptsPath -ChildPath "${scriptInstallerName}.ps1"

        if (-not (Test-Path $scriptPath)) {
            Write-Error "Script file $scriptPath does not exist." | Out-File $logFilePath -Append
            return
        }

        if ($needsElevation) {
            Write-Information "Script executing with Non-Admin permissions."
            try {
                # Using Start-Process without -Verb RunAs to run without admin privileges
                Start-Process $execShell -ArgumentList "-NoProfile", "-ExecutionPolicy Bypass", "-File `"$scriptPath`"" -Verb RunAs -Wait
            }
            catch {
                Write-Error "Failed to execute the script: $_" | Out-File $logFilePath -Append
                Read-Host "Press enter to continue..."
                exit 1
            }
        }
        else {
            Write-Information "Script executing with Non-Admin permissions."
            try {
                # Using Start-Process without -Verb RunAs to run without admin privileges
                Start-Process $execShell -ArgumentList "-NoProfile", "-ExecutionPolicy Bypass", "-File `"$scriptPath`"" -Wait
            }
            catch {
                Write-Error "Failed to execute the script: $_" | Out-File $logFilePath -Append
                Read-Host "Press enter to continue..."
                exit 1
            }
        }
    }
    else {
        $remoteScriptURL = "https://cdn.jsdelivr.net/gh/snydertechnologies/DevBox@master/windows/scripts/${scriptInstallerName}.ps1"
        try {
            $scriptContent = (New-Object System.Net.WebClient).DownloadString($remoteScriptURL)
            # Save the scriptContent to a temporary file and execute it
            $tempScriptPath = [System.IO.Path]::GetTempFileName() + ".ps1"
            $scriptContent | Out-File -FilePath $tempScriptPath
        }
        catch {
            Write-Error "Failed to download script content from $remoteScriptURL" | Out-File $logFilePath -Append
            return
        }

        if ($needsElevation) {
            try {
                
                Start-Process $execShell -ArgumentList "-NoProfile", "-ExecutionPolicy Bypass", "-File `"$tempScriptPath`"" -Verb RunAs -Wait
            }
            catch {
                Write-Error "Failed to elevate the script: $_" | Out-File $logFilePath -Append
                Read-Host "Press enter to continue..."
                Remove-Item -Path $tempScriptPath -ErrorAction SilentlyContinue
                exit 1
            }
        }
        else {
            Write-Information "Script executing with Non-Admin permissions."
            try {
                # Using Start-Process without -Verb RunAs to run without admin privileges
                Start-Process $execShell -ArgumentList "-NoProfile", "-ExecutionPolicy Bypass", "-File `"$tempScriptPath`"" -Wait
            }
            catch {
                Write-Error "Failed to execute the script: $_" | Out-File $logFilePath -Append
                Read-Host "Press enter to continue..."
                exit 1
            }
        }
    }
}

Execute-SpecificScript -scriptName $setupType
