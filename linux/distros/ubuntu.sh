#!/usr/bin/env bash
#
#
# Linux: Ubuntu 26.04 setup
#
#

source "$HOME/Dotfiles/bin/utils.sh"
REPO="$(dir_repo)"
OS="$(os)"
cd "$REPO"

if [[ "$OS" != "Ubuntu" ]]; then
  error "This script requires Ubuntu."
  exit 0
fi

warn 'Ubuntu: Requesting sudo'
sudo -v

info 'Ubuntu: Update package lists'

sudo apt update -qq > /dev/null 2>&1

info 'Ubuntu: Install base system packages'

sudo add-apt-repository universe
sudo apt update -qq > /dev/null 2>&1
sudo apt -qq --assume-yes install \
  curl git zip vim \
  ddcutil blueman \
  xclip wl-clipboard \
  language-pack-en language-pack-en-base \
  language-pack-gnome-en language-pack-gnome-en-base \
  hunspell-en-au hunspell-en-gb \
  gnome-software software-properties-gtk \
  gnome-browser-connector \
  gnome-console \
  gnome-system-monitor \
  gnome-sushi \
  gnome-terminal \
  gnome-tweaks \
  python3 python3-gpg python-is-python3 pipx > /dev/null 2>&1

info 'Ubuntu: Setup support for AppImage apps'
sudo apt -qq --assume-yes install libfuse2t64

info 'Ubuntu: Prompt Ubuntu Pro setup process'
sudo pro attach

info 'Ubuntu: Fix Security Center display of Ubuntu Pro status'
sudo snap connect desktop-security-center:system-observe

info 'Ubuntu: Configure system updates'
gsettings set com.ubuntu.update-notifier show-updates-status-icon true
gsettings set com.ubuntu.update-notifier show-livepatch-status-icon true
gsettings set com.ubuntu.update-notifier no-show-notifications false
gsettings set com.ubuntu.update-notifier notify-ubuntu-advantage-available false
gsettings set com.ubuntu.SoftwareProperties ubuntu-pro-banner-visible true

info 'Ubuntu: Update Snap config to only keep two older versions of packages'
sudo snap set system refresh.retain=2 > /dev/null 2>&1;

info 'Ubuntu: Configure ddcutil to allow for screen brightness control'
sudo gpasswd --add $USER i2c > /dev/null 2>&1

info 'Ubuntu: Upgrading APT packages'
sudo apt update -qq > /dev/null 2>&1
sudo apt upgrade -y -qq > /dev/null 2>&1;
