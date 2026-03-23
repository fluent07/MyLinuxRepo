#!/bin/bash

SELECTOR="$HOME/.config/hypr/monitors/select.sh"
PRIMARY="$HOME/.config/hypr/monitors/profiles/primary-only.sh"
STATE_FILE="$HOME/.config/hypr/monitors/.last-mode"

state() {
    if hyprctl monitors | grep -q "^Monitor HDMI-A-1"; then
        echo connected
    else
        echo disconnected
    fi
}

prev="$(state)"

while true; do
    curr="$(state)"

    if [ "$curr" != "$prev" ]; then
        if [ "$curr" = connected ]; then
            sleep 2
            "$SELECTOR"
        else
            sleep 2
            if [ -f "$STATE_FILE" ] && grep -qx "monitor-only" "$STATE_FILE"; then
                "$PRIMARY"
                echo "primary-only" > "$STATE_FILE"
            fi
        fi
        prev="$curr"
    fi

    sleep 2
done