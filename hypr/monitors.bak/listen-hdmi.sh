#!/bin/bash

SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
LOGFILE="/tmp/hypr-hdmi-listener.log"
ADD_TRIGGER="/tmp/hypr-hdmi-added.trigger"
REMOVE_TRIGGER="/tmp/hypr-hdmi-removed.trigger"

[ ! -S "$SOCKET" ] && {
    echo "Socket not found: $SOCKET" >&2
    exit 1
}

echo "started $(date)" > "$LOGFILE"

socat -U - UNIX-CONNECT:"$SOCKET" | while IFS= read -r line; do
    case "$line" in
        "monitoradded>>HDMI-A-1")
            echo "$(date '+%H:%M:%S') HDMI added" >> "$LOGFILE"
            touch "$ADD_TRIGGER"
            ;;
        "monitorremoved>>HDMI-A-1")
            echo "$(date '+%H:%M:%S') HDMI removed" >> "$LOGFILE"
            touch "$REMOVE_TRIGGER"
            ;;
    esac
done