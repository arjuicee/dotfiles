#!/bin/bash

# Get the default source (microphone)
DEFAULT_SOURCE=$(pactl get-default-source)

# Listen for volume changes and update the slider
pactl subscribe 2>/dev/null | grep --line-buffered "source" | while read -r line; do
    VOLUME=$(pactl get-source-volume "$DEFAULT_SOURCE" | grep -Po '[0-9]{1,3}(?=%)' | head -1)
    # Output the GTK slider markup with the current volume percentage
    echo "<span> </span>"  # This is a placeholder, the actual slider is created by waybar
done