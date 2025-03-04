#!/bin/bash
# Full Neovim environment setup script for Ubuntu-based systems

# System dependencies
sudo apt-get update && sudo apt upgrade && sudo apt install \
    neovim \
    git \
    nodejs \
    npm \
    python3-pip \
    openjdk-17-jdk \
    golang \
    php \
    composer \
    cargo

# Config directory setup
NVIM_DIR="$HOME/.config/nvim"
mkdir -p "$NVIM_DIR"

# Clone or update configuration
if [ -d "$NVIM_DIR/.git" ]; then
    git -C "$NVIM_DIR" pull
else
    git clone https://github.com/AlbertoSanPietro/Configs.git "$NVIM_DIR"
fi

# Install vim-plug
PLUG_URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
PLUG_PATH="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"
curl -fLo "$PLUG_PATH" --create-dirs "$PLUG_URL"

# Install plugins
nvim --headless +PlugInstall +qall

# Install Mason packages (might require manual confirmation)
echo "Installation almost complete! Now run:"
echo "nvim +MasonInstallAll"
