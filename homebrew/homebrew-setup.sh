#!/usr/bin/env bash
#
#
# Homebrew: Install on Linux or macOS using the official method and default install location
#   - Installs Homebrew based on docs from https://brew.sh/
#
#

source "$HOME/Dotfiles/bin/utils.sh"
REPO="$(dir_repo)"
OS="$(os)"
cd "$REPO"

if [[ "$OS" == "Windows" ]]; then
  error 'This script requires Linux or macOS.'
  exit 1
elif [[ "$OS" == "Linux" ]]; then
  warn 'Homebrew: Requesting sudo'
  sudo -v
fi

info 'Homebrew: Installing to default location'
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

info 'Installing Bold Brew (bbrew)'
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Valkyrie00/bold-brew/main/install.sh)"
