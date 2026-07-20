#!/usr/bin/env bash
#
#
# Run initial repo setup
#
#

REPO="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO"
DOTFILES="/home/media/Git/dotfiles"
source "$DOTFILES/bin/.helper.sh"
OS="$(os)"
OS_CLEAN="$(os_clean)"

chmod a+x "$REPO"/bin/*.sh

bash "$REPO/bin/backup.sh"

bash "$REPO/bin/setup-user.sh"

if ! command -v brew > /dev/null 2>&1; then
  info "Installing Homebrew"
  bash "$DOTFILES/homebrew/homebrew-setup-user.linux.sh"
  source "$HOME/.bashrc"
fi

info "Installing Just"
bash "$DOTFILES/just/just-setup.sh"

info "Installing Flatpak"
bash "$DOTFILES/linux/packages/linux-flatpak.sh"

info "Installing Google Chrome"
bash "$DOTFILES/linux/packages/linux-google-chrome.sh"

bash "$REPO/bin/setup-crontab.sh"

bash "$REPO/bin/setup-git.sh"

bash "$REPO/bin/setup-dev.sh"

warn "Optional: Setup symlink folders - bash $REPO/bin/setup-symlinks.sh"

warn "Optional: Install 1Password - https://1password.com/downloads/linux"

warn "Optional: Install InSync - https://www.insynchq.com/downloads/linux"

warn "Optional: Gaming Setup - bash $DOTFILES/gaming/linux-gaming.sh"
