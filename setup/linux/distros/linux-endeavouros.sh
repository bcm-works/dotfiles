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

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

info 'EndeavourOS: Installing Flatpak apps'

flatpak install --user --reinstall -y flathub net.nokyan.Resources > /dev/null 2>&1
flatpak install --user --reinstall -y flathub com.github.tchx84.Flatseal > /dev/null 2>&1
flatpak install --user --reinstall -y flathub com.mattjakeman.ExtensionManager > /dev/null 2>&1
flatpak install --user --reinstall -y flathub ca.desrt.dconf-editor > /dev/null 2>&1

success 'EndeavourOS: Setup complete, a restart is required to apply changes to the system'

