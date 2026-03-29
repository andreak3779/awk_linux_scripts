#!/usr/bin/bash
set -e

print_help() {
   cat <<EOF
NAME
   $(basename "$0") - display detailed system and hardware information

SYNOPSIS
   sudo $(basename "$0")
   $(basename "$0") [-h|--help]

DESCRIPTION
   Prints a hardware summary including system, BIOS, CPU, memory, disk,
   and network information using common Linux utilities.

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
