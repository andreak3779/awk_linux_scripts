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

printf "%b" "$HEADER System Information $FOOTER"
uname -a

printf "%b" "$HEADER Hardware Details $FOOTER"
lshw -businfo

printf "%b" "$HEADER BIOS and System Enclosure Information $FOOTER"
dmidecode --type 0,1,3

printf "%b" "$HEADER CPU Information $FOOTER"
lscpu

printf "%b" "$HEADER Memory Information $FOOTER"
free -h

printf "%b" "$HEADER Disk Usage $FOOTER"
df -h /

printf "%b" "$HEADER Network Interfaces $FOOTER"
ip -br addr
