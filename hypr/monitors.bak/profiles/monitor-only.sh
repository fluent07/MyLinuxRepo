#!/bin/bash

CURRENT_EXTERNAL="$HOME/.config/hypr/monitors/.current-external"
INTERNAL="eDP-1"

EXT_MON="$(cat "$CURRENT_EXTERNAL" 2>/dev/null)"
[ -z "$EXT_MON" ] && exit 1

hyprctl keyword monitor "$INTERNAL,disable"
sleep 0.2
hyprctl keyword monitor "$EXT_MON,preferred,0x0,1"
hyprctl dispatch dpms on