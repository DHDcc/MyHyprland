#!/usr/bin/env bash

if [ $# -eq 0 ]; then
	echo "Usage: $0 --title | --arturl | --artist | --length | --album | --source"
	exit 1
fi

# Function to get metadata using playerctl
get_metadata() {
	key=$1
	playerctl metadata --format "{{ $key }}" 2>/dev/null
}

# Check for arguments

# Function to determine the source and return an icon and text
get_source_info() {
	trackid=$(get_metadata "mpris:trackid")
	if [[ "$trackid" == *"firefox"* ]]; then
		echo -e "Firefox 󰈹"
	elif [[ "$trackid" == *"Feishin"* ]]; then
                echo -e "Feishin "
	elif [[ "$trackid" == *"spotify"* ]]; then
		echo -e "Spotify "
	elif [[ "$trackid" == *"chromium"* ]]; then
		echo -e "Chrome "
	else
		echo ""
	fi
}

# Parse the argument
case "$1" in
--title)
	title=$(get_metadata "xesam:title")
	if [ -z "$title" ]; then
		echo ""
	else
		echo "${title:0:28}" # Limit the output to 50 characters
	fi
	;;
--arturl)
	url=$(get_metadata "mpris:artUrl")
	if [[ -z "$url" ]]; then
		echo ""
	else
		if [[ "$url" == file://* ]]; then
			url=${url#file://}
		elif [[ "$url" == http://* ]]; then
			curl "$url" -o /tmp/cover.png
			mogrify -format png /tmp/cover.png
	       		url="/tmp/cover.png"
		fi
		echo "$url"
	fi
	;;
--artist)
	artist=$(get_metadata "xesam:artist")
	if [ -z "$artist" ]; then
		echo ""
	else
		echo "${artist:0:30}" # Limit the output to 50 characters
	fi
	;;
--length)
	length=$(get_metadata "mpris:length")
	if [ -z "$length" ]; then
		echo ""
	else
		# Convert length from microseconds to a more readable format (seconds)
		echo "$(echo "scale=2; $length / 1000000 / 60" | bc) m"
	fi
	;;
--status)
	status=$(playerctl status 2>/dev/null)
	if [[ $status == "Playing" ]]; then
		echo ""
	elif [[ $status == "Paused" ]]; then
		echo ""
	else
		echo ""
	fi
	;;
--album)
	album=$(playerctl metadata --format "{{ xesam:album }}" 2>/dev/null)
	if [[ -n $album ]]; then
		length=${#album}
		lim=20

		if [[ "$length" -gt "$lim" ]]; then
			echo "${album:0:$lim}..."
		else 
			echo "$album"
		fi

	else
		status=$(playerctl status 2>/dev/null)
		if [[ -n $status ]]; then
			#echo "No album"
			echo " "
		else
			echo ""
		fi
	fi
	;;
--source)
	get_source_info
	;;
*)
	echo "Invalid option: $1"
	echo "Usage: $0 --title | --arturl | --artist | --length | --album | --source"
	exit 1
	;;
esac
