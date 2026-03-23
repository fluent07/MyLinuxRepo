#!/bin/bash

TRIGGER="/tmp/hypr-monitor-hotplug"
HANDLER="$HOME/.config/hypr/monitors/hotplug.sh"

while true; do
    if [ -f "$TRIGGER" ]; then
        rm -f "$TRIGGER"
        "$HANDLER"
    fi
    sleep 1
done
