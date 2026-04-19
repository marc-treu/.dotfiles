#!/usr/bin/env bash

INTERNAL="eDP-1"
DP="DP-1"
HDMI="HDMI-2"

notify-send "toggle-monitor" "Script triggered"

# Detect connected external monitors
EXT_MONITOR=$(xrandr | grep -E "^($DP|$HDMI) connected" | awk '{print $1}' | head -n1)

if [[ -z "$EXT_MONITOR" ]]; then
    notify-send "toggle-monitor" "No external monitor active"
    exit 0
fi

notify-send "toggle-monitor" "Active external monitor: $EXT_MONITOR"

# Function to toggle resolution
toggle_resolution() {
    local OUTPUT=$1
    local RES1=$2
    local RES2=$3

    # Get current resolution
    CURRENT_RES=$(xrandr --query | grep -A1 "^$OUTPUT" | grep '*' | awk '{print $1}')

    if [[ "$CURRENT_RES" == "$RES1" ]]; then
        NEW_RES="$RES2"
    else
        NEW_RES="$RES1"
    fi

    notify-send "toggle-monitor" "Switching $OUTPUT to $NEW_RES"
    xrandr --output "$OUTPUT" --mode "$NEW_RES" --above "$INTERNAL"
}

# Toggle between 1920x1080 and 1280x1024
toggle_resolution "$EXT_MONITOR" "1920x1080" "1280x1024"
