#!/usr/bin/zsh

export SNYDERDEV_WSL_URL=https://cdn.jsdelivr.net/gh/snydertechnologies/DevBox@master/wsl
export SNYDERDEV_WSL_CONFIG_DIR=$(eval echo ~/.config/snyderdev)

# source global configs
snyderdevGlobalsBootstrap="$SNYDERDEV_WSL_CONFIG_DIR/configs/globals_bootstrap.zsh"
snyderdevGlobals="$SNYDERDEV_WSL_CONFIG_DIR/configs/globals.zsh"
if [ ! -f "$snyderdevGlobalsBootstrap" ]; then curl -L $SNYDERDEV_WSL_URL/configs/globals_bootstrap.zsh -o "$snyderdevGlobalsBootstrap"; fi
source "$snyderdevGlobalsBootstrap" # source the script (assuming it now exists locally or was successfully downloaded)
if [ ! -f "$snyderdevGlobals" ]; then curl -L $SNYDERDEV_WSL_URL/configs/globals.zsh -o "$snyderdevGlobals"; fi
source "$snyderdevGlobals" # source the script (assuming it now exists locally or was successfully downloaded)

# source homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# init starship
eval "$(starship init zsh)"

# custom stuff

sd() {
    if [[ ! -d ~/SnyderDev ]]; then
        mkdir -p ~/SnyderDev
    fi
    cd ~/SnyderDev
}
