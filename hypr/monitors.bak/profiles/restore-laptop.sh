#!/bin/bash

INTERNAL="eDP-1"

hyprctl keyword monitor "$INTERNAL,1920x1080@144,0x0,1"
hyprctl dispatch dpms on