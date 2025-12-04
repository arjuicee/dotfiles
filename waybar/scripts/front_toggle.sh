#!/bin/bash

CARD="1"
CHANNEL="Front"

STATUS=$(amixer -c $CARD get "$CHANNEL" | grep -o "\[on\]\|\[off\]" | head -1)

if [[ "$STATUS" == "[on]" ]]; then
	amixer -c $CARD set "$CHANNEL" mute
else
	amixer -c $CARD set "$CHANNEL" unmute
fi
