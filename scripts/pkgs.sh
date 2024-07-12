#!/usr/bin/env bash

# This script backs up installed packages on Arch Linux.
# to reinstall all packages use: {pacman | paru} -S - < PathToYourPackageList.txt

dir="/home/user/.backup-packages"
files=($dir/*)
backupFile="$dir/BackupPackages-$(date +%d-%m-%y).txt"
backupFileAur="$dir/BackupPackagesAur-$(date +%d-%m-%y).txt"
excludePkgs=(
	      bash \ 
	      linux-lts \ 
	      vim base \
	      base-devel \ 
	      linux \
	      linux-firmware \ 
	      linux-headers \
	      linux-lts-headers \
)

pattern=$(printf "|%s" "${excludePkgs[@]}")
pattern=${pattern:1}  # Remove the leading '|'
currentPkgs=$(pacman -Qqen | grep -v -E "^(${pattern})$")
currentPkgsAur=$(pacman -Qqem)

[ ! -d "$dir" ] && mkdir -p "$dir"
[ ${#files[@]} -gt 0 ] && rm ${dir}/*       

echo "$currentPkgs" > "$backupFile"
echo "$currentPkgsAur" > "$backupFileAur"
