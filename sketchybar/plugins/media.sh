#!/bin/bash
STATE="$(echo "$INFO" | jq -r '.state')"
PLAYING_ICON=""
PAUSED_ICON="󰏤"

# echo $STATE >> 'media_output.txt'

if [ "$STATE" = "playing" ]; then
  MEDIA="$(echo "$INFO" | jq -r '.app + ": " + .title + " - " + .artist')"
  sketchybar --set $NAME label="$MEDIA" drawing=on icon="$PLAYING_ICON"
elif ["$STATE" = "paused" ]; then
  sketchybar --set $NAME label="$MEDIA" drawing=on icon="$PAUSED_ICON"
else
  sketchybar --set $NAME drawing=off
fi
