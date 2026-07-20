#!/usr/bin/env bash
#
#
# Linux: Setup user config
#
#

REPO="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO"
source "$REPO/bin/utils.sh"
OS="$(os)"

if [[ "$OS" == "macOS" ]] || [[ "$OS" == "Windows" ]]; then
  echo "This script requires Linux."
  exit 0
fi

info "Requesting sudo"

sudo -v

info "Adding symlink at '/home/home-info.txt'"

[ -e "/home/home-info.txt" ] && sudo rm "/home/home-info.txt"
sudo ln -s "$REPO/config/home-info.txt" "/home/home-info.txt"
sudo chown $(id -u):$(id -g) "/home/home-info.txt"
sudo chmod o+r "/home/home-info.txt"

info "Adding symlink at '$HOME/.env.local'"

[ -e "$HOME/.env.local" ] && rm "$HOME/.env.local"
ln -s "$REPO/config/.env.local" "$HOME/.env.local"

info "Loading variables from '$HOME/.env.local' in to this terminal session"

source "$HOME/.env.local"

info "Bash setup"

bash "$DOTFILES/linux/bash/bash-setup.sh"

info "Requesting sudo"

sudo -v

info "Adding symlinks for the user profile image"

[ -e "$HOME/.face" ] && rm "$HOME/.face"
ln -s "$REPO/config/profile.png" "$HOME/.face"
[ -e "/var/lib/AccountsService/icons/$USER" ] && sudo rm "/var/lib/AccountsService/icons/$USER"
sudo ln -s "$REPO/config/profile.png" "/var/lib/AccountsService/icons/$USER"

if [[ "$OS_DESKTOP" == "gnome" ]]; then
  info "Applying desktop wallpaper"

  gsettings set org.gnome.desktop.background primary-color '#000000'
  gsettings set org.gnome.desktop.screensaver primary-color '#000000'
  gsettings set org.gnome.desktop.background color-shading-type 'solid'
  gsettings set org.gnome.desktop.background picture-uri "file://$REPO/config/wallpaper.jpg"
  gsettings set org.gnome.desktop.background picture-uri-dark "file://$REPO/config/wallpaper.jpg"
  gsettings set org.gnome.desktop.background picture-options 'zoom'
else
  warn "Please apply desktop wallpaper manually - $REPO/config/wallpaper.jpg"
fi
