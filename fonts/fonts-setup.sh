#!/usr/bin/env bash
#
#
# Install fonts
#
#

DIR="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO"
source "$REPO/bin/utils.sh"
OS="$(os)"

if [[ "$OS" == "Windows" ]] || [[ "$OS" == "macOS" ]]; then
  info "This script requires Linux."
  exit 1
fi

FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

info "Copying over Commit Mono Nerd Fonts from https://www.nerdfonts.com/font-downloads"

cp "$DIR/CommitMono/"*.otf "$FONT_DIR/"

if [[ "$OS" == "EndeavourOS" ]]; then
	warn 'EndeavourOS: Requesting sudo'
  sudo -v

  info 'EndeavourOS: Install Ubuntu fonts'
	sudo pacman -Syu --noconfirm ttf-ubuntu-font-family

	info 'EndeavourOS: Apply font settings to Gnome Shell'
	gsettings set org.gnome.desktop.interface font-name 'Ubuntu 11'
	gsettings set org.gnome.desktop.interface document-font-name 'Ubuntu 12'
	gsettings set org.gnome.desktop.interface monospace-font-name 'Ubuntu Mono 13'
	gsettings set org.gnome.desktop.interface font-antialiasing 'rgba'
	gsettings set org.gnome.desktop.interface font-rendering 'automatic'
elif [[ "$OS" == "Fedora" ]]; then
  warn 'Fedora: Requesting sudo'
  sudo -v

  info 'Fedora: Installing Google Noto Emoji fonts'
  sudo dnf install -y google-noto-color-emoji-fonts > /dev/null 2>&1
elif [[ "$OS" == "Ubuntu" ]]; then
  warn 'Ubuntu: Requesting sudo'
  sudo -v

  info 'Ubuntu: Installing Google Noto Emoji fonts'
  sudo apt -qq --assume-yes install fonts-noto-color-emoji > /dev/null 2>&1

  FONT_CONF_DIR="$HOME/.config/fontconfig/conf.d"
  mkdir -p "$FONT_CONF_DIR"

  if [[ ! -f "$FONT_CONF_DIR/01-emoji.conf" ]]; then
    info 'Ubuntu: Creating font config file for Noto Emoji'
    cp "$DIR/emoji-fonts.conf" "$FONT_CONF_DIR/01-emoji.conf"
  fi
fi

info 'Rebuilding the font cache'

fc-cache -f -v > /dev/null 2>&1

success 'Fonts are now ready to use'
