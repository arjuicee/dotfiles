#!/bin/bash
set -e


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Paths
PACMAN_LIST="$SCRIPT_DIR/pacman_packages.txt"
YAY_LIST="$SCRIPT_DIR/yay_packages.txt"

echo "==== Installing Pacman Packages ===="
if [[ -f "$PACMAN_LIST" ]]; then
	sudo pacman -S --needed --noconfirm - < "$PACMAN_LIST"
else
	echo "Pacman package list not found: $PACMAN_LIST"
fi

echo "==== Installing AUR packages via yay ===="
if [[ -f "$YAY_LIST" ]]; then
	yay -S --needed --noconfirm - < "$YAY_LIST"
else
	echo "Yay package list not found: $YAY_LIST"
fi

echo "==== ALL DONE ===="
