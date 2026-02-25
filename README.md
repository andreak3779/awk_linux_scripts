# awk_linux_scripts

[![Bash](https://img.shields.io/badge/Bash-5.1+-green?style=flat&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Linux](https://img.shields.io/badge/Linux-Ubuntu%20%26%20Debian-orange?style=flat&logo=linux&logoColor=white)](https://www.linux.org/)
[![Zorin OS](https://img.shields.io/badge/Zorin%20OS-Supported-blue?style=flat&logo=linux&logoColor=white)](https://zorinos.com/)
[![License](https://img.shields.io/badge/License-MIT-blue?style=flat)](LICENSE)

Handy Linux maintenance scripts to make system administration easier from the terminal. Originally written for Zorin OS and other Debian-based distributions.

## Table of Contents
- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Scripts](#scripts)
- [Installation](#installation)
- [Usage](#usage)
- [Troubleshooting](#troubleshooting)
- [Uninstallation](#uninstallation)

## Overview

This collection provides convenient terminal tools for:
- Quick access to detailed hardware information
- Automated system updates and cleanup

## Compatibility

These scripts are designed for **Ubuntu-based Linux distributions**, including:
- **Ubuntu** (20.04 LTS and later)
- **Zorin OS**
- **Linux Mint**
- **Elementary OS**
- **Pop!_OS**
- Any other Debian/Ubuntu-based distribution using `apt` package manager

The scripts use `apt` for package management, so they are **not compatible** with distributions using `dnf` (Fedora, RHEL) or `pacman` (Arch).

## Prerequisites

These scripts require the following packages to be installed:

```bash
sudo apt install lshw dmidecode
```

## Scripts

### `showhardware.sh`

Displays comprehensive hardware and system information in one command.

**Displays:**
- System information (kernel version, OS, architecture)
- Hardware bus information
- BIOS and system enclosure details
- CPU information (cores, cache, frequency)
- Memory usage and availability
- Disk usage information
- Network interface information

**Features:**
- Error handling: stops on first error
- Privilege verification: ensures it's run with sudo
- Clean formatted output with visual section separators

**Usage:**
```bash
sudo showhardware.sh
```

> **Note:** The script must be run with `sudo` and will verify privileges before proceeding.

### `checkforupdates.sh`

Automated system update and maintenance script. Performs package updates, cleanup, and refreshes Snap/Flatpak packages if installed.

**Performs:**
- Package list updates (`apt update`)
- System upgrades (`apt upgrade`)
- Unused package cleanup (`apt autoclean` and `apt autoremove`)
- Snap package refresh (if installed)
- Flatpak package upgrade (if installed)

**Features:**
- Error handling: stops on first error
- Privilege verification: ensures it's run with sudo
- Detailed status messages
- Automated dependency cleanup (may override some APT safety checks; review changes carefully before proceeding)

**Usage:**
```bash
sudo checkforupdates.sh
```

> **Note:** The script must be run with `sudo` and will verify privileges before proceeding.

## Installation

1. Clone or extract files into a directory:
   ```bash
   mkdir -p ~/scripts
   cd ~/scripts
   # Copy files here or git clone
   ```

2. Make scripts executable:
   ```bash
   chmod +x ~/scripts/*.sh
   ```

3. Add directory to PATH (choose one method):

   **Option A: Bash (for ~/.bashrc)**
   ```bash
   echo 'export PATH=~/scripts:$PATH' >> ~/.bashrc
   source ~/.bashrc
   ```

   **Option B: Bash Profile (for ~/.bash_profile)**
   ```bash
   echo 'export PATH=~/scripts:$PATH' >> ~/.bash_profile
   source ~/.bash_profile
   ```

   **Option C: System-wide (requires sudo)**
   ```bash
   for f in "$HOME"/scripts/*.sh; do
     sudo ln -s "$f" "/usr/local/bin/$(basename "$f" .sh)"
   done
   ```

4. Verify installation:
   ```bash
   sudo showhardware.sh
   ```

## Usage

Run scripts from any terminal window:

```bash
# Show hardware information (requires sudo)
sudo showhardware.sh

# Update the system (requires sudo)
sudo checkforupdates.sh
```

## Troubleshooting

**Scripts not found after installation:**
- Verify PATH was updated: `echo $PATH | grep scripts`
- Restart terminal for changes to take effect
- Try opening a new terminal window

**"Permission denied" errors:**
- Ensure scripts are executable: `chmod +x ~/scripts/*.sh`
- For system-wide installation, you need sudo

**"sudo: command not found":**
- Verify script is in a directory in your PATH: `which showhardware`
- Add the directory to PATH (see Installation section)

**`lshw` or `dmidecode` commands not found:**
- Install required packages: `sudo apt install lshw dmidecode`

**`checkforupdates` exits early:**
- The script uses error handling and stops on first error
- Check the output for which command failed
- Review system logs if needed: `journalctl -xe`

## Uninstallation

Remove installed scripts:

```bash
rm ~/scripts/showhardware.sh ~/scripts/checkforupdates.sh
```

If symlinked to `/usr/local/bin/`:
```bash
sudo rm /usr/local/bin/showhardware /usr/local/bin/checkforupdates
```

Remove from PATH (if using ~/.bashrc or ~/.bash_profile):
```bash
# Edit ~/.bashrc or ~/.bash_profile and remove the PATH line
sudo vi ~/.bashrc
# Find and delete: export PATH=~/scripts:$PATH
```

## Credits

These scripts were enhanced with assistance from [GitHub Copilot](https://github.com/features/copilot), an AI-powered code assistant. Improvements include error handling, security checks, better formatting, and additional functionality.
