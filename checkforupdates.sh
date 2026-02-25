#!/usr/bin/bash

# Check if running with sudo privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run with sudo privileges."
   exit 1
fi

echo "=== System Update Started ==="

echo "Updating package lists..."
apt update 

echo "Upgrading packages..."
apt upgrade --assume-yes --allow-downgrades --allow-remove-essential --allow-change-held-packages

echo "Cleaning apt cache..."
apt autoclean --yes
apt autoremove --yes

# Check for Snap
if command -v snap &> /dev/null; then
    echo "Refreshing Snap packages..."
    if ! snap refresh; then
        echo "Warning: Snap refresh encountered errors, continuing..."
    fi
else
    echo "Snap is not installed."
fi

# Check for Flatpak
if command -v flatpak &> /dev/null; then
    echo "Refreshing Flatpak packages..."
    if ! flatpak upgrade --assumeyes; then
        echo "Warning: Flatpak upgrade encountered errors, continuing..."
    fi
else
    echo "Flatpak is not installed."
fi

echo "=== System Update Completed Successfully ==="