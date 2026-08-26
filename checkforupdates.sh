#!/usr/bin/bash

echo "=== System Update Started ==="

echo "Updating package lists..."
sudo apt update

echo "Upgrading packages..."
sudo apt upgrade -y

echo "Cleaning apt cache..."
sudo apt autoclean --yes
sudo apt autoremove --yes

# Check for Snap
if command -v snap &> /dev/null; then
    echo "Refreshing Snap packages..."
    sudo snap refresh 
else
    echo "Snap is not installed."
fi

# Check for Flatpak
if command -v flatpak &> /dev/null; then
    echo "Refreshing Flatpak packages..."
    sudo flatpak upgrade --assumeyes
else
    echo "Flatpak is not installed."
fi

echo "=== System Update Completed Successfully ==="
