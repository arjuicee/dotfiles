#!/bin/bash

CARD="1"
CHANNEL="Front"

# Try Card 1
STATUS=$(amixer -c "$CARD" get "$CHANNEL" 2>/dev/null | grep -o "\[on\]\|\[off\]" | head -1)

# If no output, try Card 2
if [[ -z "$STATUS" ]]; then
    CARD="2"
    STATUS=$(amixer -c "$CARD" get "$CHANNEL" 2>/dev/null | grep -o "\[on\]\|\[off\]" | head -1)
fi

# If still not found, exit silently
if [[ -z "$STATUS" ]]; then
    exit 1
fi

# Toggle mute
if [[ "$STATUS" == "[on]" ]]; then
    amixer -c "$CARD" set "$CHANNEL" mute
else
    amixer -c "$CARD" set "$CHANNEL" unmute
fi

