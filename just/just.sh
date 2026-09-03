#!/usr/bin/env bash
#
#
# Setup Just command runner for the current user
#   - Installs Just, more info at https://github.com/casey/just
#   - Requires Homebrew (Linux or macOS) to be installed first - https://brew.sh/
#   - Creates a symlink at '~/justfile' to the 'justfile' in this dir
#   - When using my custom Bash Profile (setup via linux/bash/bash.sh), you can run 'ujust' from any dir
#
#

source "$HOME/Dotfiles/bin/utils.sh"
DIR="$(dir_this)"
REPO="$(dir_repo)"
OS="$(os)"
cd "$REPO"

if [[ "$OS" == "Windows" ]]; then
  echo 'Linux or macOS is required'
  exit 0
fi

if command -v brew > /dev/null 2>&1 ; then
  echo 'Just: Installing via Homebrew'

  brew reinstall fzf --force > /dev/null 2>&1
  brew reinstall just --force > /dev/null 2>&1
else
  echo 'Just: Please install Just manually - https://github.com/casey/just#installation'
  exit 0
fi

if [ -f "$HOME/justfile" ]; then
  echo "Just: Moving '$HOME/justfile' to '$HOME/justfile.old'"
  mv "$HOME/justfile" "$HOME/justfile.old"
fi

echo "Just: Adding symlink - '$HOME/justfile' > '$DIR/justfile'"

ln -s "$DIR/justfile" "$HOME/justfile"

warn 'Reloading shell to apply changes'
source "$HOME/.bashrc"
