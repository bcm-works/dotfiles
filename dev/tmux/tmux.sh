#!/usr/bin/env bash
#
#
# Tmux setup
#
#

DIR="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO"
source "$REPO/bin/.helper.sh"
OS="$(os)"
BIN="$REPO/bin"

if [[ "$OS" == "macOS" || "$OS" == "Windows" ]]; then
  echo "This script requires Linux."
  exit 0
fi

if [[ "$OS" == "Ubuntu" ]]; then
  sudo apt -y install tmux python3 pipx
fi

brew install tpm

touch "$HOME/.tmux.conf"
cp "$HOME/.tmux.conf" "$HOME/.tmux.conf.old"
cp "$DIR/.tmux.conf" "$HOME/.tmux.conf"
