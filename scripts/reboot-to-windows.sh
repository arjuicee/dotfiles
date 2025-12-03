#!/bin/bash
# Reboot into Windows from Arch Linux (GRUB-based)

WIN_ENTRY="Windows Boot Manager (on /dev/sda1)"

echo "🔹 Setting GRUB to boot into: $WIN_ENTRY"
sudo grub-reboot "$WIN_ENTRY"

echo "🔁 Rebooting into Windows..."
sudo reboot

