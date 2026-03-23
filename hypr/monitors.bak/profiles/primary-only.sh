#!/bin/bash

IGNORE_FILE="/tmp/hypr-ignore-monitor-removes"
CURRENT_EXTERNAL="$HOME/.config/hypr/monitors/.current-external"
INTERNAL="eDP-1"

: > "$IGNORE_FILE"

externals=$(hyprctl monitors | awk '/^Monitor /{print $2}' | grep -Ev '^(eDP|LVDS)')

first_external=$(printf '%s\n' "$externals" | head -n1)
[ -n "$first_external" ] && echo "$first_external" > "$CURRENT_EXTERNAL"

printf '%s\n' "$externals" | while read -r mon; do
    [ -z "$mon" ] && continue
    echo "$mon" >> "$IGNORE_FILE"
    hyprctl keyword monitor "$mon,disable"
done

sleep 0.2
hyprctl keyword monitor "$INTERNAL,1920x1080@144,0x0,1"
hyprctl dispatch dpms on