#!/usr/bin/env bash

usage() {
    cat << EOF 
usage: ${scriptName} [options]

    --title    Get the title of the source
    --arturl   Get the path to the cover of the source
    --artist   Get the name of the artist
    --duration Get the duration of the source
    --album    Get the name of the album
    --status   Get the status of the source
    --source   Get info on the source
    --help     Show this help
EOF
}

getMetadata() {
	local key="$1"
	playerctl metadata --format "{{ $key }}" || exit 1
}

getSourceInfo() {
	case "${source}" in
		*Feishin* ) echo "Feishin " ;;
		*firefox* ) echo "Firefox 󰈹" ;;
                *spotify* ) echo "Spotify " ;;
		*chromium* ) echo "Chromium " ;;
	        *) exit 1 ;;
	esac
}

getAlbumCover() {
       local previousUrlFile="/tmp/tmp.xG2g4TRv4i"
       local pathToAlbumCover="/tmp/cover.png"

       if [[ "${urlOfSource}" != $(< "${previousUrlFile}") ]]; then
                curl "${urlOfSource}" -o "${pathToAlbumCover}"
                mogrify -format png "${pathToAlbumCover}"
                echo "${urlOfSource}" > "${previousUrlFile}"

       fi
       pathToSourceCover="${pathToAlbumCover}"
}

scriptName="${0##*/}"
(( "$#" == 0 )) && usage && exit 1
source="$(getMetadata "mpris:trackid")"

case "$1" in
--title)
	titleOfSource="$(getMetadata "xesam:title")"
        titleOfSource="${titleOfSource:0:28}"

	if [[ -n "${titleOfSource}" ]]; then
		echo "${titleOfSource}"
	else
		exit 1 
	fi
	;;
--arturl)
	urlOfSource="$(getMetadata "mpris:artUrl")"

	[[ -z "${urlOfSource}" ]] && exit 1
	if [[ "${urlOfSource}" == file://* ]]; then
		pathToSourceCover=${urlOfSource#file://}
	elif [[ "${urlOfSource}" == http://* ]] || [[ "${urlOfSource}" == https://* ]]; then
		getAlbumCover
	fi

	if [[ "${source}" != *"chromium"* ]] && [[ "${source}" != *"firefox"* ]]; then
	          magick "${pathToSourceCover}" -resize "100x100^" -gravity center -extent 100x100 "${pathToSourceCover}"
	fi
	echo "${pathToSourceCover}"
	;;
--artist)
	artistName="$(getMetadata "xesam:artist")"
        artistName="${artistName/,*}"

	if [[ -n "${artistName}" ]]; then
		echo "${artistName}"
	else
		exit 1
	fi
	;;
--duration)
	durationOfSource="$(getMetadata "mpris:length")"

	[[ -z "${durationOfSource}" ]] && exit 1

	readonly DURATIN_IN_SECONDS="$((durationOfSource / 1000000))"
	readonly MINUTES="$((DURATIN_IN_SECONDS / 60))"
	readonly SECONDS="$((DURATIN_IN_SECONDS % 60))"

        printf "%02d:%02d" "${MINUTES}" "${SECONDS}"
	;;
--status)
	statusOfSource="$(playerctl status)"
        
	[[ -z "${source}" ]] && exit 1
	if [[ "${statusOfSource}" == "Paused" ]]; then
		echo ""
	elif [[ "${statusOfSource}" == "Playing" ]]; then
		echo ""
	else
		exit 1 
	fi
	;;
--album)
	albumName="$(getMetadata "xesam:album")"
	albumNameLength="${#albumName}"
	limiteOfCharacters="21"
        shortenAlbumName="${albumName:0:$limiteOfCharacters}"

	if [[ -n "${albumName}" ]]; then
		if (( albumNameLength > limiteOfCharacters )); then
			echo "${shortenAlbumName}..."
		else 
			echo "${albumName}"
		fi

	else
	       exit 1
	fi
	;;
--source)
	getSourceInfo
	;;
--help)
        usage
	;;
*)
	echo "${scriptName}: invalid option '$1'"
	echo "Try '${scriptName} --help' for more information." && exit 1
esac
