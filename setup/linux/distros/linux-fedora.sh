#!/usr/bin/env bash
#
#
# Linux: Fedora 44 setup
#
#

REPO="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$REPO"
source "$REPO/bin/utils.sh"
OS="$(os)"

if [[ "$OS" != "Fedora" ]]; then
  error "This script requires Fedora."
  exit 0
fi

info 'Fedora: Install required packages'

sudo dnf install -y git vim curl > /dev/null 2>&1

info 'Fedora: Configure Vim as the default editor'

sudo dnf install -y vim-default-editor --allowerasing > /dev/null 2>&1

info 'Fedora: Install RPM Fusion'
# From https://ounapuu.ee/posts/2024/10/14/fedora-starter-pack/
sudo dnf install -y \
	https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
	https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

info 'Fedora: Installing Gnome Sushi document preview app'

sudo dnf install -y sushi > /dev/null 2>&1

if command -v flatpak > /dev/null 2>&1 ; then
  info 'Fedora: Installing Flatpak apps'

  flatpak install --user -y flathub net.nokyan.Resources > /dev/null 2>&1
  flatpak install --user -y flathub com.github.tchx84.Flatseal > /dev/null 2>&1
  flatpak install --user -y flathub com.mattjakeman.ExtensionManager > /dev/null 2>&1
  flatpak install --user -y flathub ca.desrt.dconf-editor > /dev/null 2>&1
fi
