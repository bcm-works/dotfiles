#!/usr/bin/env bash
#
#
# Linux: Install FZF - https://github.com/junegunn/fzf
# 	- Assumes that 'linux/bash/bash-setup.sh' has already been run
#   - Assumes that the system already has Homebrew installed
#
#

REPO="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO"
source "$REPO/bin/.helper.sh"
OS="$(os)"

if [[ "$OS" == "macOS" || "$OS" == "Windows" ]]; then
  error "This script requires Linux."
  exit 0
fi

if [[ "$OS" == "Fedora" ]]; then
  info 'Fedora: Install FZF package'
  sudo dnf install -y fzf
elif [ "$(os_debian_based)" ]; then
  info "$OS: Install FZF package"
  brew install fzf
fi
