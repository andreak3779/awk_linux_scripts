#!/usr/bin/bash
sudo apt update
sudo apt upgrade --assume-yes
sudo apt autoclean
sudo apt autoremove

# Check for Snap
if command -v snap &> /dev/null; then
    echo "Snap Refresh"
    sudo snap refresh
else
    echo "Snap is not installed."
fi

# Check for Flatpak
if command -v flatpak &> /dev/null; then
    echo "FlatPak Refresh"
    sudo flatpak upgrade
else
    echo "Flatpak is not installed."
fi

exit
