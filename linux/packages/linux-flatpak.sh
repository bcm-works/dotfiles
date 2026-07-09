#!/usr/bin/env bash
#
#
# Flatpak setup
#
#

REPO="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO"
source "$REPO/bin/.helper.sh"
OS="$(os)"

if [[ "$OS" == "macOS" || "$OS" == "Windows" ]]; then
	error "This script requires Linux."
	exit 0
elif [[ "$OS" == "Ubuntu" || "$OS" == "Debian" ]]; then
	info 'Installing packages'
	sudo apt -qq --assume-yes install flatpak gnome-software-plugin-flatpak
elif [[ "$OS" == "EndeavourOS" ]]; then
	info 'Installing packages'
	sudo pacman -Syu
	sudo pacman -S flatpak
fi

info 'Adding Flathub remote'

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

success 'Flatpak setup completed, a system reboot is recommended.'