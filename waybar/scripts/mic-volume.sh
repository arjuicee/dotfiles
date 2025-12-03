#!/bin/bash

# Set your specific mic source
SOURCE="alsa_input.usb-0c76_USB_PnP_Audio_Device-00.mono-fallback"

# Get volume
VOLUME=$(pactl get-source-volume "$SOURCE" | grep -Po '[0-9]{1,3}(?=%)' | head -1)

# Get mute status
MUTE_STATUS=$(pactl list sources | grep -A 15 "Name: $SOURCE" | grep "Mute:" | awk '{print $2}')

# Output JSON for Waybar
if [ "$MUTE_STATUS" = "yes" ]; then
    echo "{\"percentage\": $VOLUME, \"icon\": \"muted\", \"class\": \"muted\", \"tooltip\": \"Microphone is muted ($VOLUME%)\" }"
else
    echo "{\"percentage\": $VOLUME, \"icon\": \"default\", \"class\": \"unmuted\", \"tooltip\": \"Microphone is active ($VOLUME%)\" }"
fi
