#!/bin/bash

SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
LOGFILE="/tmp/hypr-monitor-events.log"

[ ! -S "$SOCKET" ] && {
    echo "Socket not found: $SOCKET"
    exit 1
}

echo "started $(date)" > "$LOGFILE"

socat -U - UNIX-CONNECT:"$SOCKET" | while IFS= read -r line; do
    case "$line" in
        monitoradded*|monitoraddedv2*|monitorremoved*|monitorremovedv2*)
            echo "$(date '+%H:%M:%S') $line" >> "$LOGFILE"
            ;;
    esac
done
