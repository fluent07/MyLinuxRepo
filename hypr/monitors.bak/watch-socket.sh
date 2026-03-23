#!/bin/bash

SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
SELECTOR="$HOME/.config/hypr/monitors/select.sh"
PRIMARY="$HOME/.config/hypr/monitors/profiles/primary-only.sh"
STATE_FILE="$HOME/.config/hypr/monitors/.last-mode"
LOCKFILE="/tmp/hypr-monitor-menu.lock"
LOGFILE="/tmp/hypr-watch-socket.log"

[ ! -S "$SOCKET" ] && {
    echo "Socket not found: $SOCKET" >&2
    exit 1
}

launch_selector() {
    if [ -f "$LOCKFILE" ]; then
        echo "$(date '+%H:%M:%S') selector skipped (lockfile)" >> "$LOGFILE"
        return
    fi

    touch "$LOCKFILE"
    (
        sleep 1
        "$SELECTOR"
        rm -f "$LOCKFILE"
    ) </dev/null >/dev/null 2>>"$LOGFILE" &
}

restore_primary_if_needed() {
    if [ -f "$STATE_FILE" ] && grep -qx "monitor-only" "$STATE_FILE"; then
        echo "$(date '+%H:%M:%S') restoring primary-only" >> "$LOGFILE"
        "$PRIMARY" >/dev/null 2>>"$LOGFILE"
        echo "primary-only" > "$STATE_FILE"
    else
        echo "$(date '+%H:%M:%S') no restore needed" >> "$LOGFILE"
    fi
}

echo "started $(date)" > "$LOGFILE"

socat -U - UNIX-CONNECT:"$SOCKET" | while IFS= read -r line; do
    case "$line" in
        "monitoradded>>HDMI-A-1")
            echo "$(date '+%H:%M:%S') HDMI connected" >> "$LOGFILE"
            launch_selector
            ;;
        "monitorremoved>>HDMI-A-1")
            echo "$(date '+%H:%M:%S') HDMI removed" >> "$LOGFILE"
            restore_primary_if_needed
            ;;
    esac
done