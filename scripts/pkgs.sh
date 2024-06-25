#!/bin/bash

# This script backs up installed packages on Arch Linux.
# to reinstall all packages use : (pacman|paru) -S - < pathtoyourpackagelist.txt
## NEED TO FIX !!!
dir="$HOME/.backup-packages"
backup_file="$dir/BackupPackages-$(date +%d-%m-%y).txt"
backup_file_aur="$dir/BackupPackages-AUR-$(date +%d-%m-%y).txt"
exclude_pkgs=(
	      bash 
	      linux-lts 
	      vim base 
	      base-devel 
	      linux 
	      linux-firmware  
	      linux-headers 
	      linux-lts-headers 
)

pattern=$(printf "|%s" "${exclude_pkgs[@]}")
pattern=${pattern:1}  # Remove the leading '|'
current_pkgs=$(pacman -Qqen | grep -v -E "^(${pattern})$")
current_pkgs_aur=$(pacman -Qqem)

if [ ! -d "$dir" ]; then
    mkdir -p "$dir"
fi

echo "$current_pkgs" > "$backup_file"
echo "$current_pkgs_aur" > "$backup_file_aur"

#echo "Installed packages backed up to '$dir'"
