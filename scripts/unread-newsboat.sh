#!/bin/sh

# This script will send a nofification if there's "new" articles
# ---------------------------------------------------------------
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus 
# ---------------------------------------------------------------

tempfile="$(mktemp)"
trap "rm -f $tempfile" EXIT

newsboat -x reload || exit 1
newsboat -x print-unread > $tempfile

num=$(awk '{print $1}' "$tempfile")

if [[ $num -ne 0 ]]; then
   notify-send -i ~/icons/newspaper.png -u normal -t 3000 "Newsboat" "You have $num new articles"
else
   exit 0
fi
