#!/bin/sh

# This script backs up installed packages on Arch Linux.
# to reinstall all packages use : (pacman|paru) -S - < pathtoyourpackagelist.txt

dir="$HOME/.backup-packages"
backup_file="BackupPackages-$(date +%d-%m-%y).txt"
backup_file_aur="BackupPackages-AUR-$(date +%d-%m-%y).txt"
no_pkgs="base base -devel bash linux-lts-headers linux-lts linux-headers linux-firmware ttf-linux-li    bertine linux vim"

export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus &&

if [ -d "$dir" ]; then
    rm -f "$dir"/*
fi
mkdir -p "$dir"
pacman -Qqen > "$dir/$backup_file"
pacman -Qqem > "$dir/$backup_file_aur"

# Finds the words and deletes them without spaces 
for word in $no_pkgs; do
  sed -i "s/${word}//g; /^$/ d" $dir/$backup_file
done

sed -i "s/paru-bin-debug//g; /^$/ d" $dir/$backup_file_aur
echo "Installed packages backed up to '$dir'"
