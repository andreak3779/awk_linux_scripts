#!/usr/bin/bash
set -e

print_help() {
    cat <<EOF
NAME
    $(basename "$0") - update and clean Debian/Ubuntu-based systems

SYNOPSIS
    sudo $(basename "$0")
    $(basename "$0") [-h|--help]

DESCRIPTION
    Updates package indexes, upgrades installed packages, cleans apt cache,
    removes unused packages, and refreshes Snap/Flatpak packages if available.

OPTIONS
    -h, --help
        Show this help message and exit.

EXIT STATUS
    0 on success, non-zero on failure.
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            print_help
            exit 0
            ;;
        --)
            shift
            break
            ;;
        -*)
            echo "Error: invalid option '$1'"
            echo "Try '$(basename "$0") --help' for usage."
            exit 1
            ;;
        *)
            echo "Error: unexpected argument '$1'"
            echo "Try '$(basename "$0") --help' for usage."
            exit 1
            ;;
    esac
done

if [[ $# -gt 0 ]]; then
    echo "Error: unexpected argument(s): $*"
    echo "Try '$(basename "$0") --help' for usage."
    exit 1
fi

# Check if running with sudo privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run with sudo privileges."
   exit 1
fi

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