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

warn 'EndeavourOS: Requesting sudo access'
sudo -v

info 'EndeavourOS: Install extra system packages'

sudo pacman -Syu --noconfirm \
  gnome-software \
  gnome-tweaks \
  gnome-browser-connector \
  gnome-menus \
  git \
  git-lfs \
  zip \
  wl-clipboard \
  cronie \
  ddcutil \
  timeshift \
  discover \
  flatpak > /dev/null 2>&1

info 'EndeavourOS: Enable Bluetooth'

sudo systemctl enable --now bluetooth

info 'EndeavourOS: Enable SSH Agent service'

systemctl --user enable --now ssh-agent.socket

info 'EndeavourOS: Setup Flatpak'

bash "$REPO/setup/linux/packages/linux-flatpak.sh"

success 'EndeavourOS: Setup complete, a restart is recommended'

