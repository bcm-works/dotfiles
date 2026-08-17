#!/usr/bin/env bash
#
#
# Linux: Config to support Keychron keyboard harware
#
#

source "$HOME/Dotfiles/bin/utils.sh"
REPO="$(dir_repo)"
BIN="$REPO/bin"
THIS_DIR="$(dir_this)"
OS="$(os)"
cd "$REPO"

if [[ "$OS" == "macOS" ]] || [[ "$OS" == "Windows" ]]; then
  echo "This script requires Linux."
  exit 0
fi

echo 'Keychron Keyboards: Allow customisation of keys, lighting and firmware via https://launcher.keychron.com/'

sudo cp "$THIS_DIR/keychron-keyboards.rules" "/etc/udev/rules.d/92-keychron-keyboards.rules"

sudo udevadm control --reload-rules
sudo udevadm trigger

ibus restart
