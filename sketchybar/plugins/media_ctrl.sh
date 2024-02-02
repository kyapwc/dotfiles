#!/bin/bash

next ()
{
  /opt/homebrew/bin/nowplaying-cli next
}

back ()
{
  /opt/homebrew/bin/nowplaying-cli previous
}

play ()
{
  /opt/homebrew/bin/nowplaying-cli togglePlayPause
}

update ()
{
  PLAYING=1
  TRACK="$(/opt/homebrew/bin/nowplaying-cli get title)"
  if [ "$TRACK" != "null" ]; then
    PLAYING=0
    ARTIST="$(/opt/homebrew/bin/nowplaying-cli get artist)"
    ALBUM="$(/opt/homebrew/bin/nowplaying-cli get album)"
    APP="$(base64 -d <<< $(/opt/homebrew/bin/nowplaying-cli get clientPropertiesData) | awk -F ':' '{print $2}')"
    MEDIA="$APP: $TRACK - $ARTIST"
    PLAYBACK_RATE=$(/opt/homebrew/bin/nowplaying-cli get playbackRate)

    media_duration=$(/opt/homebrew/bin/nowplaying-cli get duration)
    elapsed_time=$(/opt/homebrew/bin/nowplaying-cli get elapsedTime)

    elapsed_minutes=$(awk -v dur="$elapsed_time" 'BEGIN {print int(dur/60)}')
    elapsed_seconds=$(awk -v dur="$elapsed_time" 'BEGIN {printf "%02.0f", dur % 60}')

    duration_minutes=$(awk -v dur="$media_duration" 'BEGIN {print int(dur/60)}')
    duration_seconds=$(awk -v dur="$media_duration" 'BEGIN {printf "%02.0f", dur % 60}')

    ELAPSED="${elapsed_minutes}:${elapsed_seconds}"
    DURATION="${duration_minutes}:${duration_seconds}"
    PROGRESS=$(printf "%.2f" $(echo "($elapsed_time / $media_duration) * 100" | bc -l))
  fi

  # echo "ELAPSED: ${ELAPSED}" >> test_progress.txt
  # echo "DURATION: ${DURATION}" >> test_progress.txt

  args=()
  if [ $PLAYING -eq 0 ]; then
    /opt/homebrew/bin/nowplaying-cli get artworkData | base64 --decode > /tmp/cover.jpg
    if [ "$ARTIST" == "" ]; then
      args+=(--set media_ctrl.title label="$TRACK"
             --set media_ctrl.album label="Podcast"
             --set media_ctrl.artist label="$ALBUM"
             --set media_ctrl.playback_slider slider.percentage=$PROGRESS
             --set media_ctrl.playback label="${ELAPSED} / ${DURATION}" )
    else
      args+=(--set media_ctrl.title label="$TRACK"
             --set media_ctrl.album label="$ALBUM"
             --set media_ctrl.artist label="$ARTIST"
             --set media_ctrl.playback_slider slider.percentage="$PROGRESS"
             --set media_ctrl.playback label="${ELAPSED} / ${DURATION}" )
    fi
    args+=(--set media_ctrl.play icon=
           --set media_ctrl.cover background.image="/tmp/cover.jpg"
                               background.color=0x00000000
           --set media_ctrl.anchor label="$MEDIA" drawing=on                      )
    if [ "$PLAYBACK_RATE" -eq 0 ]; then
      args+=(--set media_ctrl.play icon=󰐊                         )
    fi
  else
    args+=(--set media_ctrl.anchor label="-" drawing=on)
  fi
  sketchybar -m "${args[@]}"
}

mouse_clicked () {
  case "$NAME" in
    "media_ctrl.next") next
    ;;
    "media_ctrl.back") back
    ;;
    "media_ctrl.play") play
    ;;
    *) exit
    ;;
  esac
}

popup () {
  sketchybar --set media_ctrl.anchor popup.drawing=$1
}

routine() {
  case "$NAME" in
    *) update
    ;;
  esac
}

case "$SENDER" in
  "mouse.clicked") mouse_clicked
  ;;
  "mouse.entered") popup on
  ;;
  "mouse.exited"|"mouse.exited.global") popup off
  ;;
  "routine") routine
  ;;
  "forced") exit 0
  ;;
  *) update
  ;;
esac
