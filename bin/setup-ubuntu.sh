#!/usr/bin/env bash
#
#
# Setup Ubuntu
#
#

source "$HOME/Dotfiles/bin/utils.sh"
REPO="$(dir_repo)"
OS="$(os)"
cd "$REPO"

if [[ "$OS" != "Ubuntu" ]]; then
  error 'This script requires Ubuntu.'
  exit 1
fi

backup_config

bash ~/Dotfiles/linux/bash/bash.sh
bash ~/Dotfiles/dev/git/git.sh
bash ~/Dotfiles/fonts/fonts.sh
bash ~/Dotfiles/just/just.sh
bash ~/Dotfiles/linux/packages/flatpak.sh
bash ~/Dotfiles/linux/distros/ubuntu.sh
bash ~/Dotfiles/linux/gnome/gnome.sh
bash ~/Dotfiles/linux/hardware/keychron-keyboards.sh
bash ~/Dotfiles/dev/zed.sh
bash ~/Dotfiles/dev/node.sh
bash ~/Dotfiles/dev/deno.sh
bash ~/Dotfiles/dev/go.sh
bash ~/Dotfiles/linux/packages/chrome.sh
bash ~/Dotfiles/dev/docker/docker.sh

success 'Ubuntu setup completed.'
warn 'A reboot is recommended.'
