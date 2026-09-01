#!/usr/bin/env bash
#
#
# Linux: Install Mozilla Firefox
#   - Rules file is from https://support.mozilla.org/en-US/kb/linux-security-warning
#
#

source "$HOME/Dotfiles/bin/utils.sh"
REPO="$(dir_repo)"
OS="$(os)"
cd "$REPO"

if [[ "$OS" == "macOS" || "$OS" == "Windows" ]]; then
  echo "This script requires Linux."
  exit 0
fi

info 'Install Firefox via Flatpak'
flatpak install --assumeyes --or-update org.mozilla.firefox

if [[ "$OS" == "Ubuntu" ]]; then
  info 'Applying AppArmor rules for Firefox'

	warn 'Requesting sudo'
	sudo -v

	info 'Copying over rules file'
  sudo cp "$REPO/linux/packages/firefox-apparmor-rule.txt" "/etc/apparmor.d/firefox-local"

	warn 'Reloading shell to apply changes'
	source "$HOME/.bashrc"

	info 'Updating path to Firefox binaries in rules file'
	FIREFOX_BIN_PATH="$(flatpak info --show-location org.mozilla.firefox)/files/bin/firefox"
	sudo sed -i "s|<FIREFOX_BIN_PATH>|$FIREFOX_BIN_PATH|g" "/etc/apparmor.d/firefox-local"

	info 'Restarting AppArmor service'
	sudo systemctl restart apparmor.service
fi
