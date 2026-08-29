#!/usr/bin/env bash
#
#
# Setup Zed editor - https://zed.dev/
#
#

source "$HOME/Dotfiles/bin/utils.sh"
REPO="$(dir_repo)"
THIS_DIR="$(dir_this)"
BIN="$REPO/bin"
OS="$(os)"
cd "$REPO"

CONFIG_DIR="$HOME/.config/zed"
CONFIG_FILE="$THIS_DIR/settings.json"

if [[ "$OS" == "Windows" ]]; then
  error "This script requires Linux or macOS."
  exit 0
fi

warn 'Requesting sudo'
sudo -v

if [[ "$OS" == "macOS" ]]; then
  brew reinstall --cask zed
  brew reinstall shellcheck

  CONFIG_DIR="$HOME/.zed"
elif command -v flatpak > /dev/null 2>&1; then
	flatpak install --assumeyes --or-update dev.zed.Zed

	flatpak override --user --socket=wayland --socket=fallback-x11 dev.zed.Zed
	flatpak override --user --filesystem=home dev.zed.Zed
	flatpak override --user --unset-env=ZED_FLATPAK_NO_ESCAPE dev.zed.Zed

	CONFIG_DIR="$HOME/.var/app/dev.zed.Zed/config/zed"
else
  curl -f https://zed.dev/install.sh | sh
fi

mkdir -p "$CONFIG_DIR"

info "Making a backup of '$CONFIG_DIR/settings.json'"

touch "$CONFIG_DIR/settings.json"
cp "$CONFIG_DIR/settings.json" "$CONFIG_DIR/settings.json.old"

info "Linking '$CONFIG_DIR/settings.json' to '$CONFIG_FILE'"

ln -s "$CONFIG_FILE" "$CONFIG_DIR/settings.json"

success "Finished Zed setup"

if [[ "$OS" == "macOS" ]]; then
  warn "On macOS, you need to manually install the Zed CLI tool: https://zed.dev/docs/macos#installing-the-cli"
fi
