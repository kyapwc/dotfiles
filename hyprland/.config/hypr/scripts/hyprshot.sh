#!/bin/bash

actions=(
  "Window (Clipboard)"
  "Window (Clipboard + Save)"

  "Monitor (Clipboard)"
  "Monitor (Clipboard + Save)"

  "Region (Clipboard)"
  "Region (Clipboard + Save)"
)

selected_index=$(printf "%s\n" "${actions[@]}" | rofi -dmenu -config ~/dotfiles/rofi/.config/rofi/rofidmenu.rasi -p "Select Capture Action:")

case $selected_index in
  "Window (Clipboard)")
    hyprshot -m window --clipboard-only
  ;;
  "Window (Clipboard + Save)")
    hyprshot -m window --output-folder=$HOME/Pictures
  ;;
  "Monitor (Clipboard)")
    hyprshot -m monitor --clipboard-only
  ;;
  "Monitor (Clipboard + Save)")
    hyprshot -m monitor --output-folder=$HOME/Pictures
    ;;
  "Region (Clipboard)")
    hyprshot -m region --clipboard-only
  ;;
  "Region (Clipboard + Save)")
    hyprshot -m region --output-folder=$HOME/Pictures
  ;;
esac
