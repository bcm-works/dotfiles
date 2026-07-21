#!/usr/bin/env bash
#
#
# Linux: Disable Dropbox file sync checkmark icon overlays in Linux file managers
#
#

REPO="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO"
source "$REPO/bin/utils.sh"
OS="$(os)"

if [[ "$OS" == "macOS" || "$OS" == "Windows" ]]; then
  echo "This script requires Linux."
  exit 0
fi

cd "$HOME/.dropbox-dist/dropbox-lnx.x86_64-52.3.55/images/emblems"

mv emblem-dropbox-uptodate.icon emblem-dropbox-uptodate.icon.bak
mv emblem-dropbox-uptodate.png emblem-dropbox-uptodate.png.bak
