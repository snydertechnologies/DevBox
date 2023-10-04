#!/usr/bin/zsh

zshrc=~/.zshrc

echo "Installing brew package manager..."
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH" # just to suppress warning
if ! command -v brew &> /dev/null; then /bin/bash -c "$(curl -fsSL https://cdn.jsdelivr.net/gh/Homebrew/install@HEAD/install.sh)"; fi
source $zshrc

brew install gcc starship jq yq go docker-compose

# bun
curl -fsSL https://bun.sh/install | bash
bun add -g pnpm env-cmd npm nx pm2 prettier dotenv-cli yarn

# deno
curl -fsSL https://deno.land/x/install/install.sh | sh

# install NVM directly and don't let it configure ZSH for us
# don't install node yet. we'll do that in a future step.
PROFILE=/dev/null bash -c 'curl -o- https://cdn.jsdelivr.net/gh/nvm-sh/nvm@v0.39.5/install.sh | bash'
