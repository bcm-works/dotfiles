#!/usr/bin/env bash
#
#
# Linux: Ubuntu 26.04 setup
#
#

REPO="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO"
source "$REPO/bin/.helper.sh"
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

info 'Ubuntu: Install ddcutil to allow for screen brightness control'

sudo apt -qq --assume-yes install ddcutil > /dev/null 2>&1
sudo gpasswd --add $USER i2c > /dev/null 2>&1

if command -v flatpak > /dev/null 2>&1 ; then
  info 'Ubuntu: Installing Flatpak apps'

  flatpak install -y --system flathub net.nokyan.Resources > /dev/null 2>&1
  flatpak install -y --system flathub io.missioncenter.MissionCenter > /dev/null 2>&1
  flatpak install -y --system flathub com.github.tchx84.Flatseal > /dev/null 2>&1
  flatpak install -y --system flathub com.mattjakeman.ExtensionManager > /dev/null 2>&1
  flatpak install -y --system flathub ca.desrt.dconf-editor > /dev/null 2>&1
  flatpak install -y --system flathub com.usebottles.bottles > /dev/null 2>&1
  flatpak install -y --system flathub org.gnome.Boxes > /dev/null 2>&1
  flatpak install -y --system flathub org.fedoraproject.MediaWriter > /dev/null 2>&1

  flatpak install -y --user flathub org.gimp.GIMP > /dev/null 2>&1
  flatpak install -y --user flathub org.libreoffice.LibreOffice > /dev/null 2>&1
  flatpak install -y --user flathub com.fastmail.Fastmail > /dev/null 2>&1
  flatpak install -y --user flathub com.rafaelmardojai.Blanket > /dev/null 2>&1
  flatpak install -y --user flathub com.usebruno.Bruno > /dev/null 2>&1
fi

warn "You might also want to run Gnome Setup: bash $REPO/linux/gnome/gnome-setup.sh"
