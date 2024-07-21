#!/usr/bin/env bash

# Check for arguments
if [ $# -eq 0 ]; then
	echo "Usage: $0 --title | --arturl | --artist | --length | --album | --source"
	exit 1
fi

# Function to get metadata using playerctl
getMetadata() {
	key=$1
	playerctl metadata --format "{{ $key }}" 2>/dev/null
}

# Function to determine the source and return an icon and text
getSourceInfo() {
	trackid=$(getMetadata "mpris:trackid")

	case "$trackid" in
		*Feishin* ) echo -e "Feishin " ;;
                *spotify* ) echo -e "Spotify " ;;
		*chromium* ) echo -e "Chrome " ;;
	        *) : ;; # Do nothing
	esac
}

getCover() {
       local tempfile="/tmp/tmp.xG2g4TRv4i"
       local path="/tmp/cover.png"

       if [[ "$url" != $(< "$tempfile") ]]; then
                curl "$url" -o "$path" 
                mogrify -format png "$path"
                echo "$url" > "$tempfile"
       fi
       url="$path"
}

# Parse the argument
case "$1" in
--title)
	title=$(getMetadata "xesam:title")

	if [ -n "$title" ]; then
		echo "${title:0:28}" # Limit the output to 50 characters
	else
		exit 1 
	fi
	;;
--arturl)
	url=$(getMetadata "mpris:artUrl")

	[[ -z "$url" ]] && exit 1
	if [[ "$url" == file://* ]]; then
		url=${url#file://}
	elif [[ "$url" == http://* ]] || [[ "$url" == https://* ]]; then
		getCover
	fi
	echo "$url"
	;;
--artist)
	artist=$(getMetadata "xesam:artist")

	if [ -n "$artist" ]; then
		echo "${artist:0:30}" # Limit the output to 50 characters
	else
		exit 1
	fi
	;;
--length)
	duration=$(getMetadata "mpris:length")

	[ -z "$duration" ] && exit 1

	durationInSeconds=$((duration / 1000000))
	minutes=$((durationInSeconds / 60))
	seconds=$((durationInSeconds % 60))

        printf "%02d:%02d" "$minutes" "$seconds"
	;;
--status)
	status=$(playerctl status 2>/dev/null)

	if [[ $status == "Paused" ]]; then
		echo ""
	elif [[ $status == "Playing" ]]; then
		echo ""
	else
		exit 1 
	fi
	;;
--album)
	album=$(getMetadata "xesam:album")
	length=${#album}
	lim="20"

	if [[ -n $album ]]; then
		if [[ "$length" -gt "$lim" ]]; then
			echo "${album:0:$lim}..." # Cut the output
		else 
			echo "$album"
		fi

	else
	       exit 1
	fi
	;;
--source)
	getSourceInfo
	;;
*)
	echo "Invalid option: $1"
	echo "Usage: $0 --title | --arturl | --artist | --length | --album | --source"
	exit 1
	;;
esac
