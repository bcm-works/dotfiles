#!/usr/bin/env bash
#
#
# Hyprland - Setup symlink to local config directory
#
#

source "$HOME/Dotfiles/utils.sh"
REPO="$(dir_repo)"
OS="$(os)"
OS_DESKTOP="$(os_desktop_clean)"
BIN="$REPO/bin"
cd "$REPO"

HYPR_CUSTOM_DIR="$HOME/Dotfiles/config/cachyos/hyprland"

HYPR_SYSTEM_DIR="$HOME/.config/hypr"
HYPR_SYSTEM_DIR_BACKUP="$HYPR_SYSTEM_DIR.$(date "+%Y%m%d-%H%M%S").backup"

if [[ "$OS" != "CachyOS" ]]; then
  error "This script requires CachyOS Linux."
  exit 0
fi

if [[ "$OS_DESKTOP" != "hyprland" ]]; then
  error "This script requires Hyprland to be set as the Linux Desktop Environment."
  exit 0
fi

if [[ ! -d "$HYPR_CUSTOM_DIR" ]]; then
	warn "Skipped, source directory not found at '$HYPR_CUSTOM_DIR'"
	exit 0
fi

backup_config

info "Creating backup of current config dir to '$HYPR_SYSTEM_DIR_BACKUP'"
mv "$HYPR_SYSTEM_DIR" "$HYPR_SYSTEM_DIR_BACKUP"

info "Creating symlink from '$HYPR_CUSTOM_DIR' to '$HYPR_SYSTEM_DIR'"
ln -s "$HYPR_CUSTOM_DIR" "$HYPR_SYSTEM_DIR"

success 'Hyprland setup completed'
