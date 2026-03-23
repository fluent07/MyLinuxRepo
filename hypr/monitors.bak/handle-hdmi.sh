#!/bin/bash

SELECTOR="$HOME/.config/hypr/monitors/select.sh"
RESTORE="$HOME/.config/hypr/monitors/profiles/restore-laptop.sh"
STATE_FILE="$HOME/.config/hypr/monitors/.last-mode"

ADD_TRIGGER="/tmp/hypr-hdmi-added.trigger"
REMOVE_TRIGGER="/tmp/hypr-hdmi-removed.trigger"
LOCKFILE="/tmp/hypr-monitor-menu.lock"
LOGFILE="/tmp/hypr-hdmi-handler.log"

echo "started $(date)" > "$LOGFILE"

while true; do
    if [ -f "$ADD_TRIGGER" ]; then
        rm -f "$ADD_TRIGGER"
        echo "$(date '+%H:%M:%S') handling HDMI add" >> "$LOGFILE"

        if [ ! -f "$LOCKFILE" ]; then
            touch "$LOCKFILE"
            (
                sleep 1
                "$SELECTOR"
                rm -f "$LOCKFILE"
            ) </dev/null >/dev/null 2>>"$LOGFILE" &
        fi
    fi

    if [ -f "$REMOVE_TRIGGER" ]; then
        rm -f "$REMOVE_TRIGGER"
        echo "$(date '+%H:%M:%S') handling HDMI remove" >> "$LOGFILE"

        if [ -f "$STATE_FILE" ] && grep -qx "monitor-only" "$STATE_FILE"; then
            echo "$(date '+%H:%M:%S') restoring laptop only" >> "$LOGFILE"
            "$RESTORE" >/dev/null 2>>"$LOGFILE"
            echo "primary-only" > "$STATE_FILE"
        else
            echo "$(date '+%H:%M:%S') no restore needed" >> "$LOGFILE"
        fi
    fi

    sleep 1
done