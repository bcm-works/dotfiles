#!/usr/bin/env bash
#
#
# Setup Ghostty terminal emulator - https://github.com/ghostty-org/ghostty
#
#

THIS_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO"
source "$REPO/bin/.helper.sh"
OS="$(os)"

CONFIG_DIR="$HOME"
CONFIG_FILE="$THIS_DIR/config.linux.ghostty"

if [[ "$OS" == "Windows" ]]; then
  echo "This script requires Linux or macOS."
  exit 0
fi

echo 'Requesting sudo'

sudo -v

if [[ "$OS" == "macOS" ]]; then
  CONFIG_DIR="$HOME/Library/Application Support/com.mitchellh.ghostty"

  mkdir -p "$CONFIG_DIR"
  CONFIG_FILE="$THIS_DIR/config.macos.ghostty"

  # From https://ghostty.org/docs/install/binary#macos
  brew install --cask ghostty
else
  if [[ "$OS" == "EndeavourOS" ]]; then
  	# From https://ghostty.org/docs/install/binary#arch-linux
   	sudo pacman -Syu --noconfirm ghostty
  elif [[ "$OS" == "Ubuntu" || "$OS" == "Mint" ]]; then
    # From https://ghostty.org/docs/install/binary#ubuntu
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"
  elif [[ "$OS" == "Fedora" ]]; then
    # From https://ghostty.org/docs/install/binary#fedora
    sudo dnf copr enable scottames/ghostty
    sudo dnf install ghostty -y
  fi

  # Otherwise, assume this is a Linux machine that already has Ghostty installed
  # From https://ghostty.org/docs/config
  CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty"
  mkdir -p "$CONFIG_DIR"
fi

if [ -f "$CONFIG_DIR/config.ghostty" ]; then
  echo "Moving '$CONFIG_DIR/config.ghostty' to "$CONFIG_DIR/config.ghostty.old""
  mv "$CONFIG_DIR/config.ghostty" "$CONFIG_DIR/config.ghostty.old"
fi

echo "Adding symlink - '$CONFIG_FILE' > '$CONFIG_DIR/config.ghostty'"

ln -s "$CONFIG_FILE" "$CONFIG_DIR/config.ghostty"
