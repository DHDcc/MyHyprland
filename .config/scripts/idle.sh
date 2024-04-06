#!/bin/sh

swayidle -w timeout 720 'playerctl pause' 'hyprlock' timeout 1020 'systemctl suspend'


