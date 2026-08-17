#!/usr/bin/env bash
#
#
# Linux: Setup user crontab
#
#

source "$HOME/Dotfiles/bin/utils.sh"
REPO="$(dir_repo)"
OS="$(os)"
cd "$REPO"

if [[ "$OS" == "macOS" ]] || [[ "$OS" == "Windows" ]]; then
  error "This script requires Linux."
  exit 0
fi

if ! command -v crontab > /dev/null 2>&1; then
  error "Crontab is not installed, skipping setup."
  exit 0
fi

info "Setting up crontab for $USER"

crontab "$REPO/config/crontab.txt" > /dev/null 2>&1
