#!/usr/bin/env bash
#
#
# Grub Setup: Apply customisations to the Grub bootloader
#
#

DIR="$(dirname "$0" && pwd)"
REPO="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$REPO"
source "$REPO/bin/utils.sh"
OS="$(os)"

SOURCE_COLOURS="$REPO/setup/linux/grub/grub-colours.config"
TARGET_COLOURS="/etc/grub.d/06_local_colours"

if [[ "$OS" == "Windows" ]] || [[ "$OS" == "macOS" ]]; then
  echo "This script requires Linux."
  exit 1
fi

info "Requesting sudo"
sudo -v

if [[ -f "$TARGET_COLOURS" ]]; then
  info "Copying existing Grub colours script to $TARGET_COLOURS.old"
  sudo cp "$TARGET_COLOURS" "$TARGET_COLOURS.old"
fi

info "Copying over the Grub colours script to $TARGET_COLOURS"

sudo cp "$SOURCE_COLOURS" "$TARGET_COLOURS"

info "Updating file permissions"

sudo chmod +x "$TARGET_COLOURS"

info "Applying Grub config updates"

sudo update-grub

warn "You may also want to manually apply the changes in $DIR/grub-menu.config"