#!/usr/bin/env bash
#
#
# Linux: Ubuntu 26.10 setup
#
#

source "$HOME/Dotfiles/utils.sh"
REPO="$(dir_repo)"
OS="$(os)"
cd "$REPO"

if [[ "$OS" != "Ubuntu" ]]; then
  error "This script requires Ubuntu."
  exit 0
fi

warn 'Ubuntu: Requesting sudo'
sudo -v

info 'Ubuntu: Install base system packages'
sudo add-apt-repository --yes universe > /dev/null 2>&1
sudo apt update -qq > /dev/null 2>&1
sudo apt -qq --assume-yes install \
  curl git zip vim \
  ddcutil ddcui blueman libfuse2t64 \
  pavucontrol alsamixer \
  xclip wl-clipboard \
  language-pack-en language-pack-en-base \
  language-pack-gnome-en language-pack-gnome-en-base \
  hunspell-en-au hunspell-en-gb \
  gnome-browser-connector \
  gnome-console \
  gnome-system-monitor \
  gnome-sushi \
  gnome-terminal \
  gnome-tweaks \
  python3 python3-gpg python-is-python3 pipx > /dev/null 2>&1

info 'Ubuntu: Update Snap config to only keep two older versions of packages'

sudo snap set system refresh.retain=2 > /dev/null 2>&1;

info 'Ubuntu: Configure ddcutil to allow for screen brightness control'

sudo gpasswd --add $USER i2c > /dev/null 2>&1

info 'Ubuntu: Upgrading APT packages'

sudo apt update -qq > /dev/null 2>&1
sudo apt upgrade -y -qq > /dev/null 2>&1;
