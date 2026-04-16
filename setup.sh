#!/bin/bash

# Package file
PKG_FILE="package.txt"

sudo -v

if [ ! -f "$PKG_FILE" ]; then
    echo "Error: $PKG_FILE not found!"
    echo "Please create a file named $PKG_FILE with your package names."
    exit 1
fi

# Check if yay is installed
echo "🔍 Checking for yay..."
if ! command -v yay &> /dev/null; then
    echo "yay is not installed!!"
    echo "Installing yay dependencies (git and base-devel)..."
    sudo pacman -S --needed --noconfirm git base-devel
    echo "Cloning and building yay..."
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
else
    echo "yay is already installed!!"
fi

# Final Confirmation
total_pkgs=$(wc -l < "$PKG_FILE")
echo "Found $total_pkgs packages to install."
read -p "Do you want to proceed? (y/n): " confirm

if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
    echo "Installing... this may take a while."
    yay -S --needed --noconfirm - < "$PKG_FILE"
    echo "✨ All done!"
else
    echo "❌ Installation cancelled."
    exit 0
fi
