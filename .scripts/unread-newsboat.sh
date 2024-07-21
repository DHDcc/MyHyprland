#!/usr/bin/env bash

# This script will send a notification if there are any new articles.
# Add "alias newsboat='~/YOUR_SCRIPTS_DIR/newsboat'" in your zshrc (you need the newsboat script)
# -------------------------------------------------------------------
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus 
# -------------------------------------------------------------------

file=$HOME/.config/newsboat/.last-num
icon=$HOME/icons/newsboat.svg

if [ ! -f "$file" ]; then
     echo 0 > "$file"
fi

num=$(command newsboat -x reload print-unread | awk '{print $1}')
last_num=$(cat $file)

if [[ $num == $last_num ]]; then
    exit 0
elif [[ "$num" -ne 0 ]]; then
    notify-send -i "$icon" -u normal -t 4000 "Newsboat" "You have "$num" new articles"
    echo "$num" > "$file"
else
    exit 0
fi
