#!/usr/bin/env bash
#
#
# Setup crontab for a Linux User
#
#

REPO="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO"
DOTFILES="/home/media/Git/dotfiles"
source "$DOTFILES/bin/.helper.sh"
OS="$(os)"
OS_CLEAN="$(os_clean)"
bash "$REPO/bin/backup.sh"

info "Setting up crontab for $USER"

crontab "$REPO/config/crontab.txt" > /dev/null 2>&1
