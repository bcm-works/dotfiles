#!/usr/bin/env bash
#
#
# Ubuntu and EndeavourOS: Fix Bluetooth config to support high fidelity playback devices
#
#

REPO="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$REPO"
source "$REPO/bin/utils.sh"
OS="$(os)"

if [ "$(os_debian_based)" ]; then
	sudo apt -qq --assume-yes install \
		pavucontrol \
		pulseaudio \
		pulseaudio-module-bluetooth

	sudo systemctl restart bluetooth

	systemctl --user --now enable wireplumber
elif [[ "$OS" == "EndeavourOS" ]]; then
	sudo systemctl enable --now bluetooth

	sudo pacman -S --needed bluez bluez-utils
else
	error 'This script requires Ubuntu or EndeavourOS'
	exit 0
fi
