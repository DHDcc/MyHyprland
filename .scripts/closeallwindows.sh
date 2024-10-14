#!/usr/bin/env bash

windowNames=$(hyprctl clients | grep "class:" | awk '{print $2}')
windowNames=$(printf '%s' "${windowsNames,,}")

# Convert the window names into an array
IFS=$'\n' read -r -d '' -a windowsArray <<< "$windowNames"

for windowName in "${windowsArray[@]}"; do
      hyprctl dispatch closewindow "${windowName}"
done
