# awk_linux_scripts

[![Bash](https://img.shields.io/badge/Bash-5.1+-green?style=flat&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Linux](https://img.shields.io/badge/Linux-Ubuntu%20%26%20Debian-orange?style=flat&logo=linux&logoColor=white)](https://www.linux.org/)
[![Zorin OS](https://img.shields.io/badge/Zorin%20OS-Supported-blue?style=flat&logo=linux&logoColor=white)](https://zorinos.com/)
[![License](https://img.shields.io/badge/License-MIT-blue?style=flat)](LICENSE)

Handy Linux maintenance scripts to make system administration easier from the terminal. Originally written for Zorin OS and other Debian-based distributions.

## Table of Contents
- [Overview](#overview)
- [Common CLI Pattern](#common-cli-pattern)
- [Prerequisites](#prerequisites)
- [Scripts](#scripts)
- [Installation](#installation)
- [Usage](#usage)
- [Troubleshooting](#troubleshooting)
- [Uninstallation](#uninstallation)
- [Development & Planning](#development--planning)

## Overview

This collection provides convenient terminal tools for:
- Quick access to detailed hardware information
- Automated system updates and cleanup
- Google job search HTML capture for role-based queries

## Common CLI Pattern

All scripts in this repository support:
- `-h` for short help
- `--help` for long help

Example:

```bash
checkforupdates.sh -h
checkforupdates.sh --help
```

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
- Built-in `-h` / `--help` usage output

**Usage:**
```bash
sudo showhardware.sh
showhardware.sh -h
showhardware.sh --help
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
- Built-in `-h` / `--help` usage output

**Usage:**
```bash
sudo checkforupdates.sh
checkforupdates.sh -h
checkforupdates.sh --help
```

> **Note:** The script must be run with `sudo` and will verify privileges before proceeding.

### `jobsearch.sh`

Generates Google `site:` search links for job postings and saves them in a timestamped HTML report.

**Search targets:**
- `site:boards.greenhouse.io "your role"`
- `site:myworkdayjobs.com "your role"`

**Features:**
- Interactive role prompt
- Optional CSV input with `-f` / `--file`
- URL-encoded query building
- One timestamped HTML output file
- Built-in `-h` / `--help` usage output

**Usage:**
```bash
./jobsearch.sh
./jobsearch.sh -f roles.csv
./jobsearch.sh -h
./jobsearch.sh --help
```

When prompted, enter the role text (example: `site reliability engineer`).
When using `-f` / `--file`, provide a CSV where the first column is the role.

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
   sudo showhardware
   ```

## Usage

Run scripts from any terminal window:

```bash
# Show hardware information (requires sudo)
sudo showhardware
showhardware -h
showhardware --help

# Update the system (requires sudo)
sudo checkforupdates
checkforupdates -h
checkforupdates --help

# Generate Google job search links HTML (no sudo required)
./jobsearch.sh
./jobsearch.sh -h
./jobsearch.sh --help
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

**`jobsearch` exits with CSV errors:**
- Verify the file exists and is readable: `ls -l roles.csv`
- Ensure the first CSV column contains role names

**Need command usage details:**
- Run any script with `-h` or `--help` to print usage and options

## Uninstallation

Remove installed scripts:

```bash
rm ~/scripts/showhardware.sh ~/scripts/checkforupdates.sh
```

If symlinked to `/usr/local/bin/`:
```bash
sudo rm /usr/local/bin/showhardware /usr/local/bin/checkforupdates /usr/local/bin/jobsearch
```

Remove from PATH (if using ~/.bashrc or ~/.bash_profile):
```bash
# Edit ~/.bashrc or ~/.bash_profile and remove the PATH line
sudo vi ~/.bashrc
# Find and delete: export PATH=~/scripts:$PATH
```

## Development & Planning

This repository includes planning resources and specification templates for developing and maintaining Bash scripts:

### Planning Prompts

Run these interactive prompts in GitHub Copilot Chat to plan and spec out Bash scripts:

- **Bash Script Specification** (`.github/prompts/bash-specification.prompt.md`)  
  Use when starting a new script or formalizing requirements. Generates CLI interface, I/O contract, runtime behavior, safety, and testing plan.

- **Checkforupdates Plan** (`.github/prompts/plan-checkforupdates.prompt.md`)  
  Maintenance and enhancement strategy for the system update script, including verification steps and tech decisions.

- **Showhardware Plan** (`.github/prompts/plan-showhardware.prompt.md`)  
  Maintenance and enhancement strategy for the hardware inventory script, with verification checklist and future extensibility notes.

- **Google Job Search Plan** (`.github/prompts/plan-googleJobSearch.prompt.md`)  
  Implementation and feature plan for the job search link generator, including phase breakdown and regression testing.

### How to Use

1. Open GitHub Copilot Chat (`Ctrl+Shift+Alt+I` or `Cmd+Shift+Alt+I` on macOS)
2. Type `/` to see available prompts
3. Select the desired prompt and provide task-specific details

Example:

```
/bash-specification "create a log rotation script that archives files older than 30 days"
```

### Contributing

When adding new scripts or features, consider:
- Running the Bash Script Specification prompt to document expected behavior
- Following the Common CLI Pattern (see [above](#common-cli-pattern)) for consistency
- Adding a plan prompt (`.github/prompts/plan-<scriptname>.prompt.md`) for future maintainers

## Credits

These scripts were enhanced with assistance from [GitHub Copilot](https://github.com/features/copilot), an AI-powered code assistant. Improvements include error handling, security checks, better formatting, and additional functionality.
