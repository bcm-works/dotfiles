#!/usr/bin/env bash
#
#
# Arch-based Linux: Setup system
#
#

source "$HOME/Dotfiles/utils.sh"
REPO="$(dir_repo)"
OS="$(os)"
OS_ARCH="$(os_arch_based)"
cd "$REPO"

if [ ! OS_ARCH ]; then
  echo "This script requires an Arch based Linux distro."
  exit 0
fi

warn 'Requesting sudo access'
sudo -v

info 'Install system packages'

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

info 'Setup printer packages and enable related services'

sudo pacman -Syu --noconfirm \
	cups system-config-printer avahi \
	hplip sane python-pillow python-reportlab rpcbind python-pyqt5 \
	--needed > /dev/null 2>&1

sudo systemctl enable --now cups.service
sudo systemctl enable --now avahi-daemon

info 'Enable Bluetooth service'
sudo systemctl enable --now bluetooth

info 'Enable SSH Agent service'
systemctl --user enable --now ssh-agent.socket

info 'Enable Cronie service'
systemctl enable --now cronie.service

info 'Update system package cache config'
sudo paccache -rk2 > /dev/null 2>&1

# if [ -f "$REPO/config/packages/endeavouros.list.txt" ]; then
# 	info "Installing packages from '$REPO/config/packages/endeavouros.list.txt'"
# 	sudo pacman -S --noconfirm --needed - < "$REPO/config/packages/endeavouros.list.txt" > /dev/null 2>&1
# fi

# info 'Setup Flatpak'
# bash "$REPO/tools/flatpak.sh"

success 'Setup complete, a restart is recommended'
