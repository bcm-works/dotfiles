#!/usr/bin/env bash
#
#
# Linux: Fedora 44 setup
#
#

source "$HOME/Dotfiles/bin/utils.sh"
REPO="$(dir_repo)"
DIR="$(dir_this)"
OS="$(os)"
cd "$REPO"

if [[ "$OS" == "Fedora Atomic" ]]; then
	bash "$DIR/fedora-atomic.sh"
	exit 0
elif [[ "$OS" != "Fedora" ]]; then
  error "This script requires Fedora."
  exit 1
fi

info 'Fedora: Install packages'
sudo dnf install -y git vim curl > /dev/null 2>&1

info 'Fedora: Configure Vim as the default editor'
sudo dnf install -y vim-default-editor --allowerasing > /dev/null 2>&1

info 'Fedora: Add RPM Fusion package repositories'
sudo dnf install -y \
	https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
	https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

info 'Fedora: Setup Flatpak'

bash "$REPO/linux/packages/flatpak.sh"
