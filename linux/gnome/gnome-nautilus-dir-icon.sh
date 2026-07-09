#!/usr/bin/env bash
#
#
# Linux: Customise a directory icon in Nautilus for Gnome
#   - To remove a custom icon: gio set -t unset "/home/bob/dir/path" metadata::custom-icon
#
#

REPO="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO"
source "$REPO/bin/.helper.sh"
OS="$(os)"
BIN="$REPO/bin"

if [[ "$OS" == "macOS" || "$OS" == "Windows" ]]; then
  echo "This script requires Linux."
  exit 0
fi

DIR_PATH="$HOME/example"
DIR_ICON="/usr/share/icons/Yaru-prussiangreen/256x256@2x/places"

gio set -t string "$DIR_PATH" metadata::custom-icon "file://$DIR_ICON/user-home.png"
