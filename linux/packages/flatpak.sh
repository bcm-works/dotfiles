#!/usr/bin/env bash
#
#
# Flatpak setup
#
#

source "$HOME/Dotfiles/bin/utils.sh"
REPO="$(dir_repo)"
OS="$(os)"
cd "$REPO"

PACKAGES_LIST="$REPO/config/packages/flatpak.list.txt"

if [[ "$OS" == "macOS" || "$OS" == "Windows" ]]; then
	error "This script requires Linux."
	exit 0
fi

if ! command -v flatpak &> /dev/null; then
	error "Install Flatpak and add the Flathub remote first - https://flatpak.org/"
	exit 0
fi

if [[ -f "$PACKAGES_LIST" ]]; then
	info "Processing Flatpak apps from '$PACKAGES_LIST'"

	while read -r package; do
		info "  Installing $package"
    flatpak install --assumeyes --or-update "$package" > /dev/null 2>&1
	done < "$PACKAGES_LIST"
else
	warn "Skipping Flatpak app installs, file not found at '$PACKAGES_LIST'"
fi
