#!/usr/bin/env bash
#
#
# Vim setup
#
#

DIR="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$REPO"
source "$REPO/bin/utils.sh"
OS="$(os)"
BIN="$REPO/bin"

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
