#!/usr/bin/env bash
#
#
# Linux: Install Mozilla Firefox
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
  # From https://support.mozilla.org/en-US/kb/linux-security-warning
  sudo cp "$REPO/linux/packages/firefox-apparmor-rule.txt" "/etc/apparmor.d/firefox-local"

	info 'Updating path to Firefox binaries in rules file'
	sudo sed -i "s|/home/<USER>/bin/firefox/|$(dirname "$(which firefox)")/|g" "/etc/apparmor.d/firefox-local"

	info 'Restarting AppArmor service'
	sudo systemctl restart apparmor.service
fi
