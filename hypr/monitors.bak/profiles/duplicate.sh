#!/bin/bash

CURRENT_EXTERNAL="$HOME/.config/hypr/monitors/.current-external"
INTERNAL="eDP-1"

EXT_MON="$(cat "$CURRENT_EXTERNAL" 2>/dev/null)"

[ -z "$EXT_MON" ] && exit 1

hyprctl keyword monitor "$INTERNAL,1920x1080@144,0x0,1"
sleep 0.2
hyprctl keyword monitor "$EXT_MON,1920x1080@60,0x0,1,mirror,$INTERNAL"
hyprctl dispatch dpms on