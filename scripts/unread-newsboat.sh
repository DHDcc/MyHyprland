#!/bin/sh

# This script will send a notification if there are any new articles.
# Add "alias newsboat='~/YOUR_SCRIPTS_DIR/newsboat'" in your zshrc (you need the newsboat script)
# -------------------------------------------------------------------
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus 
# -------------------------------------------------------------------

rcfile=$HOME/.zshrc
icon=$HOME/icons/newspaper.png

if ! grep -q "^export NEWSBOAT_LAST_NUM=" "$rcfile"; then
     echo "export NEWSBOAT_LAST_NUM=0" >> "$rcfile"
fi
last_num=$(grep "^export NEWSBOAT_LAST_NUM=" "$rcfile" | cut -d '=' -f 2)

print_unread=$(command newsboat -x reload print-unread || exit 1)
num=$(echo "$print_unread" | awk '{print $1}')

if [[ $num -eq $last_num ]]; then
     exit 0
elif [[ $num -ne 0 ]]; then
    notify-send -i "$icon" -u normal -t 4000 "Newsboat" "You have $num new articles"
    sed -i "s|^export NEWSBOAT_LAST_NUM=.*|export NEWSBOAT_LAST_NUM=$num|" "$rcfile"
    exec zsh
else
    exit 0
fi
