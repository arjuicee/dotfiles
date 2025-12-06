#!/bin/bash

# Dependencies: grim, slurp, wl-copy, notify-send
for cmd in grim slurp wl-copy notify-send; do
    if ! command -v "$cmd" &> /dev/null; then
        notify-send "Screenshot Error" "$cmd not found."
        exit 1
    fi
done

# Screenshot path
SAVE_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SAVE_DIR"
FILENAME="$SAVE_DIR/screenshot-$(date +'%Y%m%d-%H%M%S').png"

# Take region screenshot, save, and copy to clipboard
grim -g "$(slurp)" "$FILENAME" && wl-copy < "$FILENAME"

# Notify
notify-send "Screenshot" "Region saved and copied to clipboard."
