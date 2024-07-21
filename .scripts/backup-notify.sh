#!/bin/bash

icon=~/icons/hdd.png

case "$1" in
	 "--start") notify-send -i $icon "Starting backup" "Do not shutdown your pc" ;;
	"--finish") notify-send -i $icon "Backup finished" "All done" ;;
	         *) echo -e "Usage: "$0" [OPTION]"
	            echo -e "\n --start\vstart backup notification"
	            echo -e "\n--finish\vfinish backup notification"
	            ;;
esac   
