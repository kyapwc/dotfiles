#!/usr/bin/env sh
STATUS_LABEL=$(lsappinfo info -only StatusLabel "Slack")
ICON="󰒱"

notification_color="0xffff0004"
no_notification_color="0x00000000"
notification_thread_color="0xffef9a22"

BACKGROUND_COLOR="${no_notification_color}"

if [[ $STATUS_LABEL =~ \"label\"=\"([^\"]*)\" ]]; then
    LABEL="${BASH_REMATCH[1]}"

    if [[ $LABEL == "" ]]; then
        ICON_COLOR="0xffa6da95"
        BACKGROUND_COLOR="${no_notification_color}"
    elif [[ $LABEL == "•" ]]; then
        ICON_COLOR="0xffeed49f"
        BACKGROUND_COLOR="${notification_thread_color}"
    elif [[ $LABEL =~ ^[0-9]+$ ]]; then
        ICON_COLOR="0xffed8796"
        BACKGROUND_COLOR="${notification_color}"
    else
        exit 0
    fi
else
  exit 0
fi

sketchybar --set $NAME icon=$ICON label="${LABEL}" icon.color=${ICON_COLOR} background.color="${BACKGROUND_COLOR}"
