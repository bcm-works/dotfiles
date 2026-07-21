#!/usr/bin/env bash
#
#
# Flatpak setup
#
#

REPO="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$REPO"
source "$REPO/bin/utils.sh"
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

if [[ -f "$REPO/config/flatpak/flatpak.list.txt" ]]; then
	info "Installing Flatpak app installs from '$REPO/config/flatpak/flatpak.list.txt'"
	xargs -I {} gnome-extensions-cli install {} < "$REPO/config/flatpak/flatpak.list.txt"
else
	warn "Skipping Flatpak app installs, file not found at '$REPO/config/flatpak/flatpak.list.txt'"
fi

success 'Flatpak setup completed, a system reboot is recommended.'