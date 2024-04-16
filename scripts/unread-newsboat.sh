#!/bin/sh

# ---------------------------------------------------------------
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus 
# ---------------------------------------------------------------

tempfile="$(mktemp)"
trap "rm -f $tempfile" EXIT

newsboat -x reload || exit 1
newsboat -x print-unread > $tempfile

num=$(awk '{print $1}' "$tempfile")

if [[ $num -ne 0 ]]; then
   notify-send -i ~/icons/newspaper.png -u normal -t 2000 "Newsboat" "You have $num unread articles"
else
   exit 0
fi
