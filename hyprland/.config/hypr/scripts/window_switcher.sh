#!/bin/bash

windows=$(hyprctl clients -j)
window_titles=()
while IFS= read -r line; do
  # echo $line
  window_titles+=("$line")
done < <(echo "$windows" | jq -r '.[] | .title')
workspace_ids=($(echo "$windows" | jq -r '.[] | .workspace.id'))
window_addresses=($(echo "$windows" | jq -r '.[] | .address'))

inputs=()
for (( i=0; i<${#window_titles[@]}; i++ )); do
  title="${window_titles[i]}"
  workspace_id="${workspace_ids[i]}"
  address="${window_addresses[i]}"
  inputs+=("In Workspace: $workspace_id: \"$title\"")
done

rofi_input=$(printf "%s\n" "${inputs[@]}")

selected=$(echo "$rofi_input" | rofi -dmenu -config ~/dotfiles/rofi/.config/rofi/launchers/type-4/style-2.rasi)
echo $selected

if [ -n "$selected" ]; then
  # Extract workspace ID from selected input
  workspace_id=$(echo "$selected" | awk -F':' '{print $2}' | tr -d ' ')

  # Find corresponding window address based on workspace ID
  for (( i=0; i<${#workspace_ids[@]}; i++ )); do
    if [ "${workspace_ids[i]}" = "$workspace_id" ]; then
      address="${window_addresses[i]}"
      echo $address
      # Execute your command with the selected address
      hyprctl dispatcher focuswindow "address:$address"
      break
    fi
  done
fi
