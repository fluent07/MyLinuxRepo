#!/bin/bash

# pkill -f watch-auto.sh 2>/dev/null

rm -f /tmp/hypr-monitor-menu.lock
rm -f /tmp/hypr-ignore-monitor-removes
rm -f /tmp/hypr-watch-auto.log
rm -f /tmp/hypr-monitor-layout-changing
rm -f /tmp/hypr-last-external-connect
rm -f "$HOME/.config/hypr/monitors/.current-external"

# "$HOME/.config/hypr/monitors/watch-auto.sh" &
# disown