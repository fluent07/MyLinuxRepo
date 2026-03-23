#!/bin/bash

SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
SELECTOR="$HOME/.config/hypr/monitors/select.sh"
RESTORE="$HOME/.config/hypr/monitors/profiles/restore-laptop.sh"
STATE_FILE="$HOME/.config/hypr/monitors/.last-mode"
CURRENT_EXTERNAL="$HOME/.config/hypr/monitors/.current-external"
IGNORE_FILE="/tmp/hypr-ignore-monitor-removes"
LOCKFILE="/tmp/hypr-monitor-menu.lock"
LOGFILE="/tmp/hypr-watch-auto.log"
INTERNAL="eDP-1"

[ -S "$SOCKET" ] || exit 1
touch "$IGNORE_FILE"
echo "started $(date)" > "$LOGFILE"

is_internal() {
    [[ "$1" =~ ^(eDP|LVDS) ]]
}

is_fake() {
    [[ "$1" = "FALLBACK" ]]
}

is_ignored() {
    grep -qx "$1" "$IGNORE_FILE"
}

consume_ignored() {
    grep -vx "$1" "$IGNORE_FILE" > "${IGNORE_FILE}.tmp" || true
    mv "${IGNORE_FILE}.tmp" "$IGNORE_FILE"
}

launch_menu() {
    local mon="$1"

    [ -f "$LOCKFILE" ] && return

    echo "$mon" > "$CURRENT_EXTERNAL"
    touch "$LOCKFILE"

    (
        sleep 0.5
        hyprctl dispatch focusmonitor "$INTERNAL" >/dev/null 2>&1
        hyprctl dispatch exec "$SELECTOR"
        sleep 2
        rm -f "$LOCKFILE"
    ) >/dev/null 2>>"$LOGFILE" &
}

restore_laptop() {
    echo "$(date '+%H:%M:%S') restoring laptop" >> "$LOGFILE"
    "$RESTORE" >/dev/null 2>>"$LOGFILE"
    echo "primary-only" > "$STATE_FILE"
}

socat -U - UNIX-CONNECT:"$SOCKET" | while IFS= read -r line; do
    case "$line" in
        'monitoradded>>'*)
            mon="${line#monitoradded>>}"

            if is_internal "$mon" || is_fake "$mon"; then
                continue
            fi

            echo "$(date '+%H:%M:%S') add: $mon" >> "$LOGFILE"
            launch_menu "$mon"
            ;;

        'monitorremoved>>'*)
            mon="${line#monitorremoved>>}"

            if is_internal "$mon" || is_fake "$mon"; then
                continue
            fi

            if is_ignored "$mon"; then
                echo "$(date '+%H:%M:%S') ignored remove: $mon" >> "$LOGFILE"
                consume_ignored "$mon"
                continue
            fi

            echo "$(date '+%H:%M:%S') remove: $mon" >> "$LOGFILE"
            restore_laptop
            ;;
    esac
done