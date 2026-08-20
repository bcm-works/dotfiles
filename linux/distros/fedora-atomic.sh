#!/usr/bin/env bash
#
#
# Linux: Fedora 44 Silverblue Atomic setup
#
#

source "$HOME/Dotfiles/bin/utils.sh"
REPO="$(dir_repo)"
DIR="$(dir_this)"
OS="$(os)"
cd "$REPO"

if [[ "$OS" != "Fedora Atomic" ]]; then
  error "This script requires Fedora Silverblue Atomic."
  exit 1
fi

info 'Fedora Atomic: Installing system packages'

rpm-ostree install --idempotent --allow-inactive --assumeyes \
	git git-lfs curl zip vim sushi \
	ddcutil blueman \
  xclip wl-clipboard \
	gnome-browser-connector \
  python3 pipx \
	> /dev/null 2>&1

warn 'Fedora Atomic: A system reboot is required to finalise package installations.'

