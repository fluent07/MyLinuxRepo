#!/bin/bash

get_internal_monitor() {
    hyprctl monitors -j | jq -r '.[] | select(.name|test("^(eDP|LVDS)")) | .name' | head -n1
}

get_external_monitor() {
    hyprctl monitors -j | jq -r '.[] | select(.name|test("^(eDP|LVDS)")|not) | .name' | head -n1
}

get_monitor_mode() {
    local mon="$1"
    hyprctl monitors -j | jq -r --arg mon "$mon" '.[] | select(.name==$mon) | "\(.width)x\(.height)@\(.refreshRate|floor)"'
}


# #!/bin/bash

# get_internal_monitor() {
#     hyprctl monitors | awk '/Monitor /{print $2}' | grep -E '^(eDP|LVDS)' | head -n1
# }

# get_external_monitor() {
#     hyprctl monitors | awk '/Monitor /{print $2}' | grep -Ev '^(eDP|LVDS)' | head -n1
# }

# get_internal_res() {
#     local mon="$1"
#     hyprctl monitors | awk -v m="$mon" '
#         $1=="Monitor" && $2==m {found=1}
#         found && /[0-9]+x[0-9]+@[0-9.]+/ {print $1; exit}
#     '
# }

# get_external_res() {
#     local mon="$1"
#     hyprctl monitors | awk -v m="$mon" '
#         $1=="Monitor" && $2==m {found=1}
#         found && /[0-9]+x[0-9]+@[0-9.]+/ {print $1; exit}
#     '
# }