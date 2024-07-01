#!/bin/bash

SPACE_TYPE=$(/opt/homebrew/bin/yabai -m query --spaces --space | jq -r '.type')

if [[ "$SPACE_TYPE" == "bsp" ]]; then
  IS_BSP=true
else
  IS_BSP=false
fi


case $1 in
  up)
    if $IS_BSP; then
      /opt/homebrew/bin/yabai -m window --focus north
    else
      /opt/homebrew/bin/yabai -m window --focus stack.next
    fi
  ;;
  down)
    if $IS_BSP; then
      /opt/homebrew/bin/yabai -m window --focus south
    else
      /opt/homebrew/bin/yabai -m window --focus stack.prev
    fi
  ;;
  left)
    if $IS_BSP; then
      /opt/homebrew/bin/yabai -m window --focus west
    else
      /opt/homebrew/bin/yabai -m window --focus stack.prev
    fi
  ;;
  right)
    if $IS_BSP; then
      /opt/homebrew/bin/yabai -m window --focus east
    else
      /opt/homebrew/bin/yabai -m window --focus stack.next
    fi
  ;;
esac
