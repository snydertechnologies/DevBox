#!/usr/bin/zsh

if ! command -v pwsh &>/dev/null; then
    echo "pwsh (PowerShell Core) is not installed on your system."
    echo "Please install it and try again."
    exit 1
fi

# configure git with powershell
wget $SNYDERDEV_HEAD_URL/shared/scripts/GitConfigSetup.ps1 -O /tmp/x.ps1 && pwsh /tmp/x.ps1
