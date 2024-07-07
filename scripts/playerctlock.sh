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

	case "$trackid" in
		*Feishin* ) echo -e "Feishin " ;;
                *spotify* ) echo -e "Spotify " ;;
		*chromium* ) echo -e "Chrome " ;;
	        *) : ;; # Do nothing
	esac
}

get_cover() {
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
	title=$(get_metadata "xesam:title")

	if [ ! -z "$title" ]; then
		echo "${title:0:28}" # Limit the output to 50 characters
	else
		: # Do nothing
	fi
	;;
--arturl)
	url=$(get_metadata "mpris:artUrl")

	[[ -z "$url" ]] && : # Do nothing
	if [[ "$url" == file://* ]]; then
		url=${url#file://}
	elif [[ "$url" == http://192.168.1.20:8096/* ]]; then
		get_cover
	fi
	echo "$url"
	;;
--artist)
	artist=$(get_metadata "xesam:artist")

	if [ ! -z "$artist" ]; then
		echo "${artist:0:30}" # Limit the output to 50 characters
	else
		: # Do nothing
	fi
	;;
--length)
	duration=$(get_metadata "mpris:length")
	duration_in_seconds=$((duration / 1000000))
	remaining_time=$((duration_in_seconds - current_position))
	minutes=$((remaining_time / 60))
	seconds=$((remaining_time % 60))

	if [ ! -z "$duration" ]; then
		printf "%02d:%02d" "$minutes" "$seconds"
	else
		: # Do nothing
	fi
	;;
--status)
	status=$(playerctl status 2>/dev/null)

	if [[ $status == "Paused" ]]; then
		echo ""
	elif [[ $status == "Playing" ]]; then
		echo ""
	else
		: # Do nothing
	fi
	;;
--album)
	album=$(playerctl metadata --format "{{ xesam:album }}" 2>/dev/null)
	length=${#album}
	lim="20"

	if [[ -n $album ]]; then
		if [[ "$length" -gt "$lim" ]]; then
			echo "${album:0:$lim}..." # Cut the output
		else 
			echo "$album"
		fi

	else
	      : # Do nothing
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
