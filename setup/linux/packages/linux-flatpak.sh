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
elif [[ "$(os_debian_based)" ]]; then
	info "$OS: Installing packages"
	sudo apt -qq --assume-yes install flatpak gnome-software-plugin-flatpak
elif [[ "$OS" == "EndeavourOS" ]]; then
	info 'EndeavourOS: Installing packages'
	sudo pacman -Syu --noconfirm flatpak > /dev/null 2>&1
fi

info 'Adding Flathub remote'

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

if [[ -f "$REPO/config/packages/flatpak.list.txt" ]]; then
	info "Installing Flatpak apps from '$REPO/config/packages/flatpak.list.txt'"
	xargs -a "$REPO/config/packages/flatpak.list.txt" flatpak install --assumeyes --or-update
else
	warn "Skipping Flatpak app installs, file not found at '$REPO/config/packages/flatpak.list.txt'"
fi

success 'Flatpak setup completed, a system reboot is recommended.'