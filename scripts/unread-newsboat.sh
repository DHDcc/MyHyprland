#!/bin/sh

if [ -r "$XDG_RUNTIME_DIR/bus" ]; then
	  export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
fi

tempfile="/tmp/num.txt"
notify=$(newsboat -x print-unread)

newsboat -x reload || exit 1

newsboat -x print-unread | grep -o 0 > $tempfile

if grep -q -o 0 "$tempfile"; then
   exit 0
else
   notify-send -i ~/icons/newspaper.png -u normal -t 2000 "Newsboat" "You have $notify"
fi



