#!/bin/bash
bar_color="#f993ff"

function get_brightness {
  brightnessctl info | grep -oP '\(\K[0-9]+%'
}

function get_brightness_icon {
  brightness_icon=""
}

function show_brightness_notif {
  brightness=$(get_brightness)
  get_brightness_icon
  dunstify -t 1000 -r 2593 -u normal "$brightness_icon $brightness" -h int:value:$brightness -h string:hlcolor:$bar_color
}

case $1 in
  up)
    brightnessctl -s set +20%
    show_brightness_notif
  ;;
  down)
    brightnessctl -s set 20%-
    show_brightness_notif
  ;;
esac
