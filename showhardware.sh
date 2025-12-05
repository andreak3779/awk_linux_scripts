#!/usr/bin/bash

echo "System Information:"
uname -a
echo

echo "Hardware Details:"
sudo lshw -businfo
echo

echo "BIOS and System Enclosure Information:"
sudo dmidecode --type 0,1,3
echo

echo "CPU Information:"
lscpu
echo

echo "Memory Information:"
free -h
