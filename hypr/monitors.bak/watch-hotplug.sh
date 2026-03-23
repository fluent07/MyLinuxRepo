#!/bin/bash

SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
PROFILE_DIR="$HOME/.config/hypr/monitors/profiles"
SELECTOR="$HOME/.config/hypr/monitors/select.sh"
LOCKFILE="/tmp/hypr-monitor-menu.lock"

[ ! -S "$SOCKET" ] && exit 1

socat -U - UNIX-CONNECT:"$SOCKET" | while read -r line; do
    case "$line" in
        monitoradded*|monitoraddedv2*)
            if [ ! -f "$LOCKFILE" ]; then
                touch "$LOCKFILE"
                sleep 1
                "$SELECTOR"
                rm -f "$LOCKFILE"
            fi
            ;;
        monitorremoved*|monitorremovedv2*)
            sleep 2
            if ! hyprctl monitors | grep -q "^Monitor HDMI-A-1"; then
                "$PROFILE_DIR/primary-only.sh"
            fi
            ;;
    esac
done