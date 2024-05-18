#!/bin/sh

# This script will send a nofification if there's "new" articles
# Add "alias newsboat='~/YOUR_SCRIPTS_DIR/newsboat'" in your zshrc (you need the newsboat script)
# ---------------------------------------------------------------
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus 
# ---------------------------------------------------------------

last_num_file=last_num_file.txt
tempfile="$(mktemp)"
trap "rm -f $tempfile" EXIT

if [ ! -f $last_num_file ]; then
     echo 0 > $last_num_file
fi
last_num=$(cat $last_num_file)

$(which newsboat) -x reload print-unread  > $tempfile || exit 1

num=$(awk '{print $1}' "$tempfile")

if [[ $num -eq $last_num ]]; then
	exit 0
elif
   [[ $num -ne 0 ]]; then
        notify-send -i ~/icons/newspaper.png  -u normal -t 4000 "Newsboat" "You have $num new articles"
        echo $num > $last_num_file
else
    exit 0
fi
