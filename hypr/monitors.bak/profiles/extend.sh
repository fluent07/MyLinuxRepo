#!/bin/bash

CURRENT_EXTERNAL="$HOME/.config/hypr/monitors/.current-external"
INTERNAL="eDP-1"

EXT_MON="$(cat "$CURRENT_EXTERNAL" 2>/dev/null)"

[ -z "$EXT_MON" ] && exit 1

hyprctl keyword monitor "$INTERNAL,1920x1080@144,0x0,1"
sleep 0.2
hyprctl keyword monitor "$EXT_MON,preferred,1920x0,1"
hyprctl dispatch dpms on