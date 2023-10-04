# GitConfigSetup.ps1

git config --global core.longpaths true # support long paths
git config --global push.autoSetupRemote true
git config --global pull.rebase true

# Commands for non-Windows platforms go here
if (-not $IsWindows -and $PSVersionTable.Platform -ne "Win32NT") {
    git config --global credential.helper "cache --timeout=10604800" # not needed with Windows Credential Manager
}

# Prompt the user for their git name
$gitName = Read-Host "Enter your name (e.g., 'John Doe') for your git config"

# Check if the input for gitName is not empty
if (-not [string]::IsNullOrWhiteSpace($gitName)) {
    # Set git user.name
    git config --global user.name $gitName
    Write-Host "Git user.name has been set to: $gitName"
}
else {
    Write-Warning "Name input was empty. Git user.name was not set."
}

# Prompt the user for their git email
$gitEmail = Read-Host "Enter your email (e.g., 'john.doe@example.com') for your git config"

# Check if the input for gitEmail is not empty
if (-not [string]::IsNullOrWhiteSpace($gitEmail)) {
    # Set git user.email
    git config --global user.email $gitEmail
    Write-Host "Git user.email has been set to: $gitEmail"
}
else {
    Write-Warning "Email input was empty. Git user.email was not set."
}
