#!/usr/bin/bash
echo "=== System Update Started ==="

echo "Updating package lists..."
apt update

echo "Upgrading packages..."
apt upgrade -y

echo "Cleaning apt cache..."
apt autoclean --yes
apt autoremove --yes

# Check for Snap
if command -v snap &> /dev/null; then
    echo "Refreshing Snap packages..."
    snap refresh --stable
else
    echo "Snap is not installed."
fi

# Check for Flatpak
if command -v flatpak &> /dev/null; then
    echo "Refreshing Flatpak packages..."
    flatpak upgrade --assumeyes
else
    echo "Flatpak is not installed."
fi

echo "=== System Update Completed Successfully ==="
