#!/usr/bin/env bash

# This script will send a notification if there are any new articles in newsboat. 
# Add "alias newsboat='~/YOUR_SCRIPTS_DIR/newsboat'" in your zshrc (you need the newsboat script)
# -------------------------------------------------------------------
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus 
# -------------------------------------------------------------------

previousArticlesNumberFile="${HOME}/.config/newsboat/.previous_articles_number"
newsboatIcon="${HOME}/icons/newsboat.svg"
currentArticlesNumber="$(command newsboat -x reload print-unread)"
currentArticlesNumber="${currentArticlesNumber//[^0-9]/}"

[[ -z "${currentArticlesNumber}" ]] && exit 1
[[ ! -f "${previousArticlesNumberFile}" ]] && echo 0 > "${previousArticlesNumberFile}"

previousArticlesNumber="$(< $previousArticlesNumberFile)"

if [[ "${currentArticlesNumber}" -ne 0 ]] && [[ "${currentArticlesNumber}" -ne "${previousArticlesNumber}" ]]; then
     notify-send -i "${newsboatIcon}" -u normal -t 5000 "Newsboat" "You have ${currentArticlesNumber} new articles"
     echo "${currentArticlesNumber}" > "${previousArticlesNumberFile}"
else
     exit 0
fi
