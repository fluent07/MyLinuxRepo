#!/bin/bash

SELECTOR="$HOME/.config/hypr/monitors/select.sh"
PRIMARY="$HOME/.config/hypr/monitors/profiles/primary-only.sh"
LOGFILE="/tmp/hypr-watch-poll.log"

get_state() {
    if hyprctl monitors -j | jq -e '.[] | select(.name=="HDMI-A-1")' >/dev/null 2>&1; then
        echo connected
    else
        echo disconnected
    fi
}

prev="$(get_state)"
echo "=== started $(date) ===" >> "$LOGFILE"
echo "initial prev=$prev" >> "$LOGFILE"

while true; do
    curr="$(get_state)"
    echo "$(date '+%H:%M:%S') prev=$prev curr=$curr" >> "$LOGFILE"

    if [ "$curr" != "$prev" ]; then
        echo "$(date '+%H:%M:%S') change detected: $prev -> $curr" >> "$LOGFILE"

        if [ "$curr" = "connected" ]; then
            echo "$(date '+%H:%M:%S') launching selector" >> "$LOGFILE"
            "$SELECTOR" >> "$LOGFILE" 2>&1
        else
            echo "$(date '+%H:%M:%S') running primary-only fallback" >> "$LOGFILE"
            "$PRIMARY" >> "$LOGFILE" 2>&1
        fi

        prev="$curr"
    fi

    sleep 2
done