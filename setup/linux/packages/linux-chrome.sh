#!/usr/bin/env bash
#
#
# Linux: Install Google Chrome
#
#

REPO="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$REPO"
source "$REPO/bin/utils.sh"
OS="$(os)"

if [[ "$OS" == "macOS" || "$OS" == "Windows" ]]; then
  echo "This script requires Linux."
  exit 0
fi

info 'Installing Chrome via Flatpak'
flatpak install --assumeyes --or-update com.google.Chrome

info 'Allow Chrome to access files in the user home dir'
sudo flatpak override --filesystem=home com.google.Chrome

info 'Fix Webcam video output display issues'
sudo flatpak override --env="CHROME_EXTRA_FLAGS=--disable-gpu-compositing" com.google.Chrome
