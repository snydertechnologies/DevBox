#!/usr/bin/zsh

export SNYDERDEV_HEAD_URL=https://cdn.jsdelivr.net/gh/snydertechnologies/DevBox@HEAD
export SNYDERDEV_WSL_URL=$SNYDERDEV_HEAD_URL/wsl
export SNYDERDEV_WSL_CONFIG_DIR=$(eval echo ~/.config/snyderdev)

export STARSHIP_CONFIG=$(eval echo $SNYDERDEV_WSL_CONFIG_DIR/configs/starship.toml)

# bun
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun" # bun completions
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# deno
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# rust
export CARGO_HOME="$HOME/.cargo"
export PATH="$CARGO_HOME/bin:$PATH"