#!/usr/bin/bash
sudo apt update
sudo apt upgrade
sudo apt autoclean
sudo apt autoremove
echo "Snap Refresh"
sudo snap refresh
echo "FlatPak Refresh"
sudo flatpak upgrade
exit
