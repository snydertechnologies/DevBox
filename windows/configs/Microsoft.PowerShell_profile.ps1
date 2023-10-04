$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1
# after the choco helper has loaded, refresh the env
refreshenv

# set the starship configuration and init
$ENV:STARSHIP_CONFIG = "$HOME\.config\starship.toml"
Invoke-Expression (&starship init powershell)

function setSnyderDevDrive {
  $drive = "C"
  $defaultPath = "SnyderDev"

  if ($null -ne $env:SNYDER_SNYDERDEV_DRIVE) { $drive = $env:SNYDER_SNYDERDEV_DRIVE }
  if ($null -ne $env:SNYDER_SNYDERDEV_SUBPATH) { $defaultPath = $env:SNYDER_SNYDERDEV_SUBPATH }
  
  $path = "${drive}:\${defaultPath}"

  if (-Not (Test-Path $path)) {
      New-Item -Path $path -ItemType Directory
  }
  # Set persistent environment variable
  [System.Environment]::SetEnvironmentVariable('SNYDER_SNYDERDEV_PATH', $path, [System.EnvironmentVariableTarget]::User)
}
setSnyderDevDrive # call the function

function sd {
  Set-Location -Path $env:SNYDER_SNYDERDEV_PATH
}
