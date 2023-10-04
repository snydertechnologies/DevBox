#!/bin/zsh

# Usage:  sudo apt install zsh -y && curl -fsSL https://cdn.jsdelivr.net/gh/snydertechnologies/DevBox@HEAD/wsl/WslSetup.zsh | zsh

echo "\n\n"
echo "Welcome to the setup script for SnyderWslSetup ..."
echo "===============================================\n"

zshrc=~/.zshrc
bashrc=~/.bashrc
zprofile=~/.zprofile
zlogin=~/.zlogin
profile=~/.profile

# download and set environment variables
jsdelivr=https://cdn.jsdelivr.net/gh/snydertechnologies/DevBox@HEAD
githubRaw=https://raw.githubusercontent.com/snydertechnologies/DevBox/HEAD
export SNYDERDEV_WSL_URL=$jsdelivr/wsl
export SNYDERDEV_WSL_CONFIG_DIR=$(eval echo ~/.config/snyderdev)

globalsBootstrap="$SNYDERDEV_WSL_CONFIG_DIR/configs/globals_bootstrap.zsh"
mkdir -p "$SNYDERDEV_WSL_CONFIG_DIR/configs"
curl -L $SNYDERDEV_WSL_URL/configs/globals_bootstrap.zsh -o $globalsBootstrap
source $globalsBootstrap

sudo apt update && sudo apt upgrade -y
sudo apt install wget curl unzip build-essential software-properties-common apt-transport-https zsh git gawk fonts-powerline -y

sudo apt update && sudo apt upgrade -y # Update the list of packages
source /etc/os-release # Get the version of Ubuntu
wget -q https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb # Download the Microsoft repository keys
sudo dpkg -i packages-microsoft-prod.deb # Register the Microsoft repository keys
rm packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install -y powershell # Install PowerShell

curl -L $SNYDERDEV_WSL_URL/configs/home/.zlogin > ~/.zlogin
curl -L $SNYDERDEV_WSL_URL/configs/home/.zprofile > ~/.zprofile
curl -L $SNYDERDEV_WSL_URL/configs/home/.zshrc > ~/.zshrc

curl -L $SNYDERDEV_WSL_URL/configs/custom.zshrc > $SNYDERDEV_WSL_CONFIG_DIR/configs/custom.zshrc
curl -L $SNYDERDEV_WSL_URL/configs/starship.toml > $SNYDERDEV_WSL_CONFIG_DIR/configs/starship.toml

source $zshrc

# install cron updater
echo "0 0 */14 * * root /bin/zsh -c '\$(curl -fsSL $SNYDERDEV_WSL_URL/scripts/999-S-CronUpdate.zsh)'" | sudo tee /etc/cron.d/snyderdev-update > /dev/null

# initial setup of the baseline
curl -L "$SNYDERDEV_WSL_URL/scripts/000-S-InitSetup.zsh" | zsh

# overwrite ~/.bashrc
curl -L $SNYDERDEV_WSL_URL/configs/home/.bashrc > ~/.bashrc

# cleanup and remove Oh-My-Zsh stuff if it existed
[[ -e ~/.oh-my-zsh ]] && rm -Rf ~/.oh-my-zsh
[[ -e ~/.zshrc.pre-oh-my-zsh ]] && rm ~/.zshrc.pre-oh-my-zsh

# exit
echo "\n"
echo "==============================================================="
echo "==============================================================="
echo "\n"
echo "  Nice! You're all set up. We'll change your default shell:    "
echo "  $ chsh -s $(which zsh)                                       "
echo "  $ exec zsh                                       "
echo "\n"
echo "==============================================================="
echo "==============================================================="
echo "\n"

chsh -s $(which zsh)
exec zsh