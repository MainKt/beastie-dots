#!/bin/sh

run() { ! pgrep -f "$1" && "$@"& }

run picom
run dunst
run wmname LG3D
run unclutter
run feh --bg-scale --randomize ~/pics/wallpapers/
run xinput disable $(xinput list | grep -i touchpad | grep -o 'id=[0-9]*' | cut -d= -f2)
run xbacklight -set 50
run backlight 50
