#!/usr/bin/env bash
#
#
# Linux: Install Google Chrome
#
#

source "$HOME/Dotfiles/bin/utils.sh"
REPO="$(dir_repo)"
OS="$(os)"
cd "$REPO"

if [[ "$OS" == "macOS" || "$OS" == "Windows" ]]; then
  echo "This script requires Linux."
  exit 0
fi

info 'Installing Chrome via Flatpak'
flatpak install --assumeyes --or-update com.google.Chrome

info 'Fix clipboard features'
flatpak override --user --socket=wayland --socket=fallback-x11 com.google.Chrome

info 'Allow Chrome to access files in the user home dir'
flatpak override --user --filesystem=home com.google.Chrome

info 'Fix Webcam video output display issues'
flatpak override --user --env="CHROME_EXTRA_FLAGS=--disable-gpu-compositing" com.google.Chrome
