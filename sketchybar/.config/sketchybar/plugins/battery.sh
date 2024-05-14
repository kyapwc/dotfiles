#!/bin/sh
low_battery_background_color="0xffe12715"
medium_battery_background_color="0xff86e115"
high_battery_background_color="0xff00ff2e"

PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')
BACKGROUND_COLOR=${high_battery_background_color}

if [ $PERCENTAGE = "" ]; then
  exit 0
fi

case ${PERCENTAGE} in
  9[0-9]|100)
    ICON=""
    BACKGROUND_COLOR="${high_battery_background_color}"
  ;;
  [6-8][0-9])
    ICON=""
    BACKGROUND_COLOR="${medium_battery_background_color}"
  ;;
  [3-5][0-9])
    ICON=""
    BACKGROUND_COLOR="${low_battery_background_color}"
  ;;
  [1-2][0-9])
    ICON=""
    BACKGROUND_COLOR="${low_battery_background_color}"
  ;;
  *) ICON=""
esac

if [[ $CHARGING != "" ]]; then
  ICON=""
fi

# The item invoking this script (name $NAME) will get its icon and label
# updated with the current battery status
sketchybar --set $NAME icon="$ICON" label="${PERCENTAGE}%" background.color="${BACKGROUND_COLOR}"
