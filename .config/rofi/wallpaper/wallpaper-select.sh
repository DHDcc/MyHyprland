#!/bin/sh

# I DID NOT WRITE THIS SCRIPT, THE OP OF THIS SCRIPT IS https://github.com/JaKooLit
# I did update a couple thing lines, but that's about it

# This script for selecting wallpapers (SUPER W)

SCRIPTSDIR="$HOME/.scripts"

# WALLPAPERS PATH
wallDIR="$HOME/.config/swww/wallpapers"

# Transition config
FPS=170
TYPE="fade"
DURATION=1
BEZIER=".43,1.19,1,.4"
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION"

# Retrieve image files
PICS=($(ls "${wallDIR}" | grep -E ".jpg$|.jpeg$|.png$|.gif$"))

# Rofi command
# rofi_command="~/.config/rofi/launchers/type-4/launcher.sh"
rofi_command="rofi -show -dmenu -config ~/.config/rofi/wallpaper/wallpaper.rasi"

menu() {
  for i in "${!PICS[@]}"; do
    # Displaying .gif to indicate animated images
    if [[ -z $(echo "${PICS[$i]}" | grep .gif$) ]]; then
      printf "$(echo "${PICS[$i]}" | cut -d. -f1)\x00icon\x1f${wallDIR}/${PICS[$i]}\n"
    else
      printf "${PICS[$i]}\n"
    fi
  done
}

swww query || swww init

main() {
  choice=$(menu | ${rofi_command})

  # No choice case
  if [[ -z $choice ]]; then
    exit 0
  fi

  # Find the index of the selected file
  pic_index=-1
  for i in "${!PICS[@]}"; do
    filename=$(basename "${PICS[$i]}")
    if [[ "$filename" == "$choice"* ]]; then
      pic_index=$i
      break
    fi
  done

  if [[ $pic_index -ne -1 ]]; then
    swww img "${wallDIR}/${PICS[$pic_index]}" $SWWW_PARAMS 
  else
    echo "Image not found."
    exit 1
  fi
}

# Check if rofi is already running
if pidof rofi > /dev/null; then
  pkill rofi
  exit 0
fi

main
