#!/bin/sh

#Pause all media players using playerctl

for player in $(playerctl --list-all); do 
	playerctl --player="$player" pause; 
done
