#!/usr/bin/zsh

# set wsl default so docker command is accessible
wsl.exe --setdefault Ubuntu-22.04

# dapr
wget -q https://cdn.jsdelivr.net/gh/dapr/cli@HEAD/install/install.sh -O - | /bin/bash

if command -v docker >/dev/null && command -v dapr >/dev/null; then
    dapr uninstall --all
    dapr init
fi

dapr --version
