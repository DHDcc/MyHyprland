#!/bin/sh

DIR="$HOME/.config/swww/wallpapers"
PICS=()

while IFS= read -r -d '' file; do
  PICS+=("$file")
done < <(find "${DIR}" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" \) -print0)

if [ "${#PICS[@]}" -eq 0 ]; then
  echo "Error: No image files found in the specified directory: ${DIR}" >&2
  exit 1
fi

RANDOMPICS="${PICS[$((RANDOM % ${#PICS[@]}))]}"

change_swww() {
  echo "Running change_swww function..."
  swww query || swww init
  if [ -f "${RANDOMPICS}" ]; then
    echo "Setting wallpaper to ${RANDOMPICS}"
    notify-send -t 1710 -i ~/icons/wallpapers.icon.png --hint int:transient:1 "Changing wallpaper...."
    swww img "${RANDOMPICS}" --transition-fps 170 --transition-type any --transition-duration 3
  else
    echo "Error: Image file not found: ${RANDOMPICS}" >&2
    exit 1
  fi
}

change_current() {
  echo "Running change_current function..."
  change_swww
}

echo "Starting script..."
case "$1" in
  "swww")
    change_swww
    ;;
  "s")
    change_current
    ;;
  *)
	  echo "Error: Try 'swww' or 's' at the end of : $0 " >&2
    exit 1
    ;;
esac
