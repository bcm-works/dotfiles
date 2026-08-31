#!/usr/bin/env bash
#
#
# Save current package names to the package list files
#
#

source "$HOME/Dotfiles/bin/utils.sh"
CFG="$(dir_repo)/config/packages"
cd "$CFG"

if [ "$(command -v flatpak)" ]; then
	info "Saving installed Flatpak package names to '$CFG/flatpak.list.txt'"
	flatpak list --app --columns=application | tail -n +1 > "$CFG/flatpak.list.txt"
fi

if [ "$(command -v gnome-extensions)" ]; then
	info "Saving installed Gnome Extension names to '$CFG/gnome-extension.list.txt'"
	gnome-extensions list --user > "$CFG/gnome-extension.list.txt"
fi

if [ "$(command -v pacman)" ]; then
	info "Saving installed Pacman package names to '$CFG/pacman.list.txt'"
	pacman -Qqm > "$CFG/pacman.list.txt"
fi
