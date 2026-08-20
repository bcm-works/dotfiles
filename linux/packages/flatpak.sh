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
	info "Installing Flatpak apps from '$PACKAGES_LIST'"

	while IFS= read -r line; do
		IS_INSTALLED="$(flatpak list --columns=application | grep -q "^$line$" && echo "true")"
		if [[ "$IS_INSTALLED" != "true" ]]; then
    		info "  $line - Installing"
    		flatpak install --assumeyes --or-update "$line" > /dev/null 2>&1
    	else
    		success "  $line - Installed, skipping"
    	fi
	done < "$PACKAGES_LIST"

	warn 'Flatpak setup completed, a system reboot is recommended.'
else
	warn "Skipping Flatpak app installs, file not found at '$PACKAGES_LIST'"
fi

