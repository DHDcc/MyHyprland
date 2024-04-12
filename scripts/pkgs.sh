#!/bin/sh

# This script backs up installed packages on Arch Linux.
# to reinstall all packages use : (pacman|paru) -S - < pathtoyourpackagelist.txt

DIR="$HOME/.backup-packages"
BACKUP_FILE="BackupPackages-$(date +%d-%m-%y).txt"
BACKUP_FILE_AUR="BackupPackages-AUR-$(date +%d-%m-%y).txt"

if [ -d "$DIR" ]; then
    rm -f "$DIR"/*
fi
mkdir -p "$DIR"
pacman -Qqen > "$DIR/$BACKUP_FILE"
pacman -Qqem > "$DIR/$BACKUP_FILE_AUR"
echo "Installed packages backed up to '$DIR'"
