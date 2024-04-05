#!/bin/sh

# Update Arch Linux mirrorlist
sudo reflector -c FR -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist
