#!/usr/bin/env bash

check_connectors() {
    for output in /sys/class/drm/*/status; do
        full_connector=$(echo "$output" | awk -F'/' '{print $(NF-1)}')
        
	status=$(cat "${output}")

        if [[ "${status}" == "connected" ]]; then
            connector=$(echo "${full_connector}" | sed 's/^card[0-9]\+-//')
            printf '%s\n' "${connector^^}"
        fi
    done
}

check_connectors
