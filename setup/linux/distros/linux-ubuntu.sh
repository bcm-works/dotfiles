#!/usr/bin/env bash
#
#
# Linux: Ubuntu 26.04 setup
#
#

REPO="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$REPO"
source "$REPO/bin/utils.sh"
OS="$(os)"

if [[ "$OS" != "Ubuntu" ]]; then
  error "This script requires Ubuntu."
  exit 0
fi

info 'Ubuntu: Requesting sudo'

sudo -v

info 'Ubuntu: Update package lists'

sudo apt update -qq > /dev/null 2>&1

info 'Ubuntu: Install base system packages'

sudo apt -qq --assume-yes install \
  gnome-software \
  software-properties-gtk \
  gnome-tweaks \
  curl \
  git \
  zip \
  vim \
  gnome-sushi \
  gnome-browser-connector \
  python3 \
  python3-gpg \
  python-is-python3 \
  pipx \
  xclip > /dev/null 2>&1

info 'Ubuntu: Prompt Ubuntu Pro setup process'

sudo pro attach

info 'Ubuntu: Fix Security Center display of Ubuntu Pro status'

sudo snap connect desktop-security-center:system-observe

info 'Ubuntu: Update Snap config to only keep two older versions of packages'

sudo snap set system refresh.retain=2 > /dev/null 2>&1;

info 'Ubuntu: Install ddcutil to allow for screen brightness control'

sudo apt -qq --assume-yes install ddcutil > /dev/null 2>&1
sudo gpasswd --add $USER i2c > /dev/null 2>&1

info 'Ubuntu: Setup Flatpak'

bash "$REPO/setup/linux/linux-flatpak.sh"

warn "You might also want to run Gnome Setup: bash $REPO/setup/linux/gnome/gnome-setup.sh"
