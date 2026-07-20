#!/usr/bin/env bash
#
#
# Setup dev frameworks and apps
#
#

REPO="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO"
DOTFILES="/home/media/Git/dotfiles"
source "$DOTFILES/bin/.helper.sh"
OS="$(os)"
OS_CLEAN="$(os_clean)"
bash "$REPO/bin/backup.sh"

info "Dev setup"

bash "$DOTFILES/dev/dev-setup.sh"

info "Zed setup"

bash "$DOTFILES/dev/zed/zed-setup.sh"

info "Ghostty setup"

bash "$DOTFILES/dev/ghostty/ghostty-setup.sh"
