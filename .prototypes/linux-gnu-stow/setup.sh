#!/usr/bin/env bash
#
#
# Linux/macOS - Setup GNU Stow
#
#

source "$HOME/Dotfiles/bin/utils.sh"
REPO="$(dir_repo)"
DIR="$(dir_this)"
OS="$(os)"
cd "$REPO"

if [[ "$OS" == "Fedora" ]]; then
	info 'Fedora: Installing GNU Stow'
	sudo dnf install -y stow > /dev/null 2>&1
elif [[ "$OS" == "Ubuntu" ]]; then
	info 'Ubuntu: Installing GNU Stow'
	sudo apt -qq --assume-yes install stow > /dev/null 2>&1
elif [[ "$OS" == "macOS" ]]; then
	info 'macOS: Installing GNU Stow via Homebrew'
	brew install stow > /dev/null 2>&1
else
	error 'This script does not support your OS.'
	exit 1
fi
