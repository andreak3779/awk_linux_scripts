#!/usr/bin/bash
set -e

# Check if running with sudo privileges (required for lshw and dmidecode)
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run with sudo privileges."
   exit 1
fi

# Section separators for better readability
HEADER="\n===================="
FOOTER="====================\n"

printf "$HEADER System Information $FOOTER"
uname -a

printf "$HEADER Hardware Details $FOOTER"
lshw -businfo

printf "$HEADER BIOS and System Enclosure Information $FOOTER"
dmidecode --type 0,1,3

printf "$HEADER CPU Information $FOOTER"
lscpu

printf "$HEADER Memory Information $FOOTER"
free -h

printf "$HEADER Disk Usage $FOOTER"
df -h /

printf "$HEADER Network Interfaces $FOOTER"
ip -br addr
