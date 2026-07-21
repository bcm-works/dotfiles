#!/usr/bin/env bash
#
#
# EndeavourOS: Setup system
#
#

REPO="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$REPO"
source "$REPO/bin/utils.sh"
OS="$(os)"

if [[ "$OS" != "EndeavourOS" ]]; then
  echo "This script requires EndeavourOS."
  exit 0
fi

info 'EndeavourOS: Requesting sudo access'
sudo -v

info 'EndeavourOS: Setup initial packages and Flatpak'

sudo pacman -Syu --noconfirm \
  gnome-software \
  gnome-tweaks \
  gnome-browser-connector \
  gnome-menus \
  git \
  zip \
  wl-clipboard \
  flatpak > /dev/null 2>&1

info 'EndeavourOS: Setup Flatpak'

bash "$REPO/setup/linux/linux-flatpak.sh"

success 'EndeavourOS: Setup complete, a restart is required to apply changes to the system'

