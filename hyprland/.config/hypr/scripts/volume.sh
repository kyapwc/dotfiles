#!/bin/bash
volume_step=5
max_volume=100
bar_color="#f993ff"

function get_volume {
  pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]{1,3}(?=%)' | head -1
}

function get_mute {
  pactl get-sink-mute @DEFAULT_SINK@ | grep -Po '(?<=Mute: )(yes|no)'
}

function get_volume_icon {
  volume=$(get_volume)
  mute=$(get_mute)
  if [ "$volume" -eq 0 ] || [ "$mute" == "yes" ] ; then
    volume_icon=""
  elif [ "$volume" -lt 50 ]; then
    volume_icon=""
  else
    volume_icon=""
  fi
}

function show_volume_notif {
  volume=$(get_mute)
  get_volume_icon
  dunstify -i audio-volume-muted-blocking -t 1000 -r 2593 -u normal "$volume_icon $volume%" -h int:value:$volume -h string:hlcolor:$bar_color
}

function show_mute_volume_notif {
  volume=$(get_mute)
  get_volume_icon
  if [ "$mute" == "yes" ]; then
    dunstify -i audio-volume-muted-blocking -t 1000 -r 2593 -u normal "Volume OFF"
  else
    dunstify -i audio-volume-muted-blocking -t 1000 -r 2593 -u normal "$volume_icon $volume%" -h int:value:$volume -h string:hlcolor:$bar_color
  fi
}

case $1 in
  up)
    pactl set-sink-mute @DEFAULT_SINK@ 0
    volume=$(get_volume)
    if [ $(( "$volume" + "$volume_step" )) -gt $max_volume ]; then
        pactl set-sink-volume @DEFAULT_SINK@ $max_volume%
    else
        pactl set-sink-volume @DEFAULT_SINK@ +$volume_step%
    fi
    show_volume_notif
  ;;
  down)
    pactl set-sink-volume @DEFAULT_SINK@ -$volume_step%
    show_volume_notif
  ;;
  mute)
    pactl set-sink-mute @DEFAULT_SINK@ toggle
    show_mute_volume_notif
  ;;
esac
