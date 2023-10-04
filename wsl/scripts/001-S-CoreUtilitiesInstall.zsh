#!/usr/bin/zsh

source ~/.zshrc

# nodejs
if command -v nvm &> /dev/null; then
    nvm install v20 && nvm use v20 && nvm alias default v20
else
    echo "nvm is not installed or not available in the current PATH."
fi

# dotnet
cat << EOL | sudo tee /etc/apt/preferences
Package: dotnet* aspnet* netstandard*
Pin: origin "archive.ubuntu.com"
Pin-Priority: -10
EOL

installDotnet() {
    
    if dotnet --list-sdks | grep -Eq "6\.0|7\.0"; then
        echo "dotnet 6.0 or 7.0 is already installed"
    else
        sudo apt remove 'dotnet*' 'aspnet*' 'netstandard*'
        sudo touch /etc/apt/preferences
        # https://learn.microsoft.com/en-us/dotnet/core/install/linux-ubuntu#register-the-microsoft-package-repository
        # Get Ubuntu version
        declare repo_version=$(if command -v lsb_release &> /dev/null; then lsb_release -r -s; else grep -oP '(?<=^VERSION_ID=).+' /etc/os-release | tr -d '"'; fi)
        # Download Microsoft signing key and repository
        wget https://packages.microsoft.com/config/ubuntu/$repo_version/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
        # Install Microsoft signing key and repository
        sudo dpkg -i packages-microsoft-prod.deb
        # Clean up
        rm packages-microsoft-prod.deb
        # Update packages
        sudo apt update && sudo apt upgrade -y
        sudo apt-get install dotnet-sdk-6.0 dotnet-sdk-7.0
    fi

    if dotnet --list-sdks | grep -q "8.0"; then
        echo "dotnet 8.0 is already installed"
    else
        mkdir /tmp/dotnet_install && cd /tmp/dotnet_install
        curl -L https://aka.ms/install-dotnet-preview -o install-dotnet-preview.sh
        sudo bash install-dotnet-preview.sh --channel 8.0
        cd ~ && rm -rf /tmp/dotnet_install
    fi

    dotnet --list-sdks
}
installDotnet

# install rustup
curl https://sh.rustup.rs -sSf | sh -s -- -y


# overwrite ~/.zshrc in case anything was added to it
curl -L $SNYDERDEV_WSL_URL/configs/home/.zshrc > ~/.zshrc