#!/usr/bin/env bash
#
#
# Linux: Install Google Chrome
#
#

REPO="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO"
source "$REPO/bin/.helper.sh"
OS="$(os)"

if [[ "$OS" == "macOS" || "$OS" == "Windows" ]]; then
  echo "This script requires Linux."
  exit 0
fi

# Install Google Chrome via Flatpak
flatpak install -y com.google.Chrome

# Allow Chrome to access files in the user home dir
sudo flatpak override --filesystem=home com.google.Chrome

# Fix Webcam video output display issues
sudo flatpak override --env="CHROME_EXTRA_FLAGS=--disable-gpu-compositing" com.google.Chrome
