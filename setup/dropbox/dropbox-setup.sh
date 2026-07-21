#!/usr/bin/env bash
#
#
# Dropbox config
#
#

DIR="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO"
source "$REPO/bin/utils.sh"
OS="$(os)"

INSTALL_MESSAGE='Please install Dropbox manually from https://www.dropbox.com/install'

if [[ "$OS" == "Windows" ]]; then
  echo "This script requires Linux or macOS."
  exit 1
elif [[ "$OS" == "macOS" ]]; then
  if [ -d "/Applications/Dropbox.app/Contents" ]; then
    success 'Dropbox is already installed.'
  else
    warn "$INSTALL_MESSAGE"
    exit 1
  fi
else
  if command -v dropbox > /dev/null 2>&1 ; then
    success 'Dropbox is already installed.'
  else
  	if [ "$(os_debian_based)" ]; then
			info 'Installing supporting system packages'

	   	sudo apt -qq --assume-yes install \
					python3 python-is-python3 python3-gpg > /dev/null 2>&1

      info 'Installing Dropbox'

      DB_DEB="$HOME/Downloads/temp-dropbox-amd64.deb"
      rm -rf "$DB_DEB"
      curl --output "$DB_DEB" "https://linux.dropbox.com/packages/ubuntu/dropbox_2026.05.06_amd64.deb" > /dev/null 2>&1
      sudo apt update -qq > /dev/null 2>&1
      sudo apt -qq --assume-yes install "$DB_DEB" > /dev/null 2>&1
      rm -rf "$DB_DEB"
    else
      echo "$INSTALL_MESSAGE"
      exit 1
    fi
  fi
fi

if [ -d "$HOME/Dropbox" ]; then
  echo "Coping over 'rules.dropboxignore.txt' to '$HOME/Dropbox/rules.dropboxignore'."
  cp -n "$DIR/rules.dropboxignore.txt" "$HOME/Dropbox/rules.dropboxignore"
else
  echo "Could not find Dropbox directory."
  echo "Please copy over '$DIR/rules.dropboxignore.txt' to your Dropbox directory,"
  echo "then rename it to 'rules.dropboxignore'."
fi

info 'Configure Dropbox to start on login and disable transfer speed limits'

dropbox autostart y
dropbox throttle unlimited unlimited
dropbox start
