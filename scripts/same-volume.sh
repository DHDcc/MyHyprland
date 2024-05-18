#!/bin/sh

vol=100

while true; do
        current_volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | cut -d% -f1)	
	if [[ $current_volume -lt $vol ]]; then
		pactl set-sink-volume @DEFAULT_SINK@ +$((vol - current_volume))%
        elif [[ $current_volume -gt $vol ]]; then
		pactl set-sink-volume @DEFAULT_SINK@ -$((current_volume - vol))%
        else 
		break
        fi

done

