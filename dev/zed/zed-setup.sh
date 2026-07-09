#!/usr/bin/env bash
#
#
# Setup Zed editor - https://zed.dev/
#
#

THIS_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO"
source "$REPO/bin/.helper.sh"
OS="$(os)"
BIN="$REPO/bin"

CONFIG_DIR="$HOME/.config/zed"
CONFIG_FILE="$THIS_DIR/settings.json"

if [[ "$OS" == "Windows" ]]; then
  echo "This script requires Linux or macOS."
  exit 0
fi

echo 'Requesting sudo'

sudo -v

if [[ "$OS" == "macOS" ]]; then
  brew reinstall --cask zed
  brew reinstall shellcheck

  CONFIG_DIR="$HOME/.zed"
else
  curl -f https://zed.dev/install.sh | sh
fi

mkdir -p "$CONFIG_DIR"

echo "Making a backup of '$CONFIG_DIR/settings.json'"

touch "$CONFIG_DIR/settings.json"
cp "$CONFIG_DIR/settings.json" "$CONFIG_DIR/settings.json.old"

echo "Copying '$CONFIG_FILE' to '$CONFIG_DIR/settings.json'"

cp "$CONFIG_FILE" "$CONFIG_DIR/settings.json"

echo "Finished Zed setup"

if [[ "$OS" == "macOS" ]]; then
  echo "On macOS, you need to manually install the Zed CLI tool: https://zed.dev/docs/macos#installing-the-cli"
fi
