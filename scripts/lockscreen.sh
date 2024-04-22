#!/bin/sh

# Lock screen and pause all media
 
for player in $(playerctl --list-all); do
        playerctl --player="$player" pause;
done

hyprctl keyword general:cursor_inactive_timeout 1
hyprlock
hyprctl keyword general:cursor_inactive_timeout 0
