#!/usr/bin/env bash
#
#
# Vim setup
#
#

source "$HOME/Dotfiles/bin/utils.sh"
REPO="$(dir_repo)"
DIR="$(dir_this)"
BIN="$REPO/bin"
OS="$(os)"
cd "$REPO"

if [[ "$OS" == "macOS" || "$OS" == "Windows" ]]; then
  echo "This script requires Linux."
  exit 0
elif [[ "$OS" == "Ubuntu" ]]; then
  sudo apt -y install vim
  sudo select-editor
  sudo update-alternatives --config editor
elif [[ "$OS" == "EndeavourOS" ]]; then
  sudo pacman -Syu
  sudo pacman -S vim
  echo 'export EDITOR=vim' >> "$HOME/.bashrc"
fi

mkdir -p "$HOME/.vim"

[[ -d "$HOME/.vim/colors" ]] && cp -r "$HOME/.vim/colors" "$HOME/.vim/colors.old"
[[ -d "$HOME/.vimrc" ]] && mv "$HOME/.vimrc" "$HOME/.vimrc.old"

ln -s "$DIR/colours" "$HOME/.vim/colors"
ln -s "$DIR/.vimrc" "$HOME/.vimrc"
