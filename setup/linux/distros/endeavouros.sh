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

info 'EndeavourOS: Install some system packages'

sudo pacman -Syu --noconfirm \
  git \
  git-lfs \
  zip \
  bluez bluez-libs bluez-utils \
  wl-clipboard \
  cronie \
  chafa \
  ddcutil \
  fastfetch \
  timeshift \
  discover \
  flatpak > /dev/null 2>&1

info 'EndeavourOS: Setup printer packages and enable related services'
sudo pacman -Syu cups system-config-printer avahi --needed > /dev/null 2>&1
sudo systemctl enable --now cups.service
sudo systemctl enable --now avahi-daemon

info 'EndeavourOS: Enable Bluetooth service'
sudo systemctl enable --now bluetooth

info 'EndeavourOS: Enable SSH Agent service'
systemctl --user enable --now ssh-agent.socket

info 'EndeavourOS: Enable Cronie service'
systemctl enable --now cronie.service

info 'EndeavourOS: Update system package cache config'
sudo paccache -rk2 > /dev/null 2>&1

if [ -f "$REPO/config/packages/endeavouros.list.txt" ]; then
	info "EndeavourOS: Installing packages from '$REPO/config/packages/endeavouros.list.txt'"
	sudo pacman -S --noconfirm --needed - < "$REPO/config/packages/endeavouros.list.txt" > /dev/null 2>&1
fi

info 'EndeavourOS: Setup Flatpak'

bash "$REPO/setup/linux/packages/flatpak.sh"

success 'EndeavourOS: Setup complete, a restart is recommended'
