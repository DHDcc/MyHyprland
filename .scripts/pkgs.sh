#!/usr/bin/env bash

# This script backs up installed packages on Arch Linux.
# to reinstall all packages use: {pacman | paru} -S - < PathToYourPackageList.txt

backupPackagesDir="/home/user/.backup-packages"
backupPackagesfiles=("${backupPackagesDir}"/*)
backupFilePacman="${backupPackagesDir}/BackupPackagesPacman-$(date +%d-%m-%y).txt"
backupFileAur="${backupPackagesDir}/BackupPackagesAur-$(date +%d-%m-%y).txt"
excludedPackages=(
	      "bash"
	      "zsh"
	      "linux-lts" 
	      "vim"
	      "base" 
	      "base-devel"  
	      "linux" 
	      "linux-firmware"
	      "linux-headers"
	      "linux-lts-headers"
)
excludedPackages=$(printf "|%s" "${excludedPackages[@]}")
excludedPackages=${excludedPackages:1}  # Remove the leading '|'
currentPkgsPacman=$(pacman -Qqen | grep -v -E "^(${excludedPackages})$")
currentPkgsAur=$(pacman -Qqem | grep -v -E "^(${excludedPackages})$")

[[ ! -d "${backupPackagesDir}" ]] && mkdir -p "${backupPackagesDir}"
[[ "${#backupPackagesfiles[@]}" -gt 0 ]] && rm -f "${backupPackagesDir}"/*  # Check if backupPackages directory contains files

echo "${currentPkgsPacman}" > "${backupFilePacman}"
echo "${currentPkgsAur}" > "${backupFileAur}"
