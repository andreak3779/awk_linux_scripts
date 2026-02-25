#!/usr/bin/bash
set -e

# Check if running with sudo privileges (required for lshw and dmidecode)
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run with sudo privileges."
   exit 1
fi

# Color codes for better readability
HEADER="\n===================="
FOOTER="====================\n"

printf "%b System Information %b" "$HEADER" "$FOOTER"
uname -a

printf "%b Hardware Details %b" "$HEADER" "$FOOTER"
lshw -businfo

printf "%b BIOS and System Enclosure Information %b" "$HEADER" "$FOOTER"
dmidecode --type 0,1,3

printf "%b CPU Information %b" "$HEADER" "$FOOTER"
lscpu

printf "%b Memory Information %b" "$HEADER" "$FOOTER"
free -h

printf "%b Disk Usage %b" "$HEADER" "$FOOTER"
df -h /

printf "%b Network Interfaces %b" "$HEADER" "$FOOTER"
ip -br addr
