#!/bin/bash

PROFILE_DIR="$HOME/.config/hypr/monitors/profiles"
STATE_FILE="$HOME/.config/hypr/monitors/.last-mode"
INTERNAL="eDP-1"
LAYOUT_FLAG="/tmp/hypr-monitor-layout-changing"
THEME="$HOME/.config/hypr/monitors/monitor-menu.rasi"
hyprctl dispatch focusmonitor "$INTERNAL" >/dev/null 2>&1
sleep 0.1

choice=$(printf "󰍹  Primary only\n󰍺  Monitor only\n󰹑  Duplicate\n󰍹  Extend" | rofi -dmenu -i -p "Display" -theme "$THEME")

case "$choice" in
  "Primary only")
    mode="primary-only"
    script="$PROFILE_DIR/primary-only.sh"
    ;;
  "Monitor only")
    mode="monitor-only"
    script="$PROFILE_DIR/monitor-only.sh"
    ;;
  "Duplicate")
    mode="duplicate"
    script="$PROFILE_DIR/duplicate.sh"
    ;;
  "Extend")
    mode="extend"
    script="$PROFILE_DIR/extend.sh"
    ;;
  *)
    exit 0
    ;;
esac

echo "$mode" > "$STATE_FILE"
touch "$LAYOUT_FLAG"
"$script"
(
    sleep 3
    rm -f "$LAYOUT_FLAG"
) >/dev/null 2>&1 &