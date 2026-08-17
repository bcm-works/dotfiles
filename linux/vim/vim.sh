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

rm -rf "$HOME/.vim.old"

mkdir -p "$HOME/.vim"
cp -r "$HOME/.vim" "$HOME/.vim.old"
rm -rf "$HOME/.vim"

git clone "https://github.com/flazz/vim-colorschemes.git" "$HOME/.vim"

touch "$HOME/.vimrc"

cp "$HOME/.vimrc" "$HOME/.vimrc.old"
cp "$DIR/.vimrc" "$HOME/.vimrc"
