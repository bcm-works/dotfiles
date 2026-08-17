#!/usr/bin/env bash
#
#
# Setup 'just' command runner for the current user
#   - Requires Homebrew (Linux or macOS) to be installed first: https://brew.sh/
#   - Installs 'just'
#   - Creates a symlink at '~/justfile' to the 'justfile' in this dir
#   - You may need to restart your Terminal before 'just' command work properly
#   - Then you can run from any directory inside of your user dir: just
#   - More info at https://github.com/casey/just
#
#

DIR="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO"
source "$REPO/bin/utils.sh"
OS="$(os)"

if [[ "$OS" == "Windows" ]]; then
  echo 'Linux or macOS is required'
  exit 1
fi

if command -v brew > /dev/null 2>&1 ; then
  echo 'Just: Installing via Homebrew'

  brew reinstall fzf --force > /dev/null 2>&1
  brew reinstall just --force > /dev/null 2>&1
else
  echo 'Just: Please install Just manually - https://github.com/casey/just#installation'
  exit 1
fi

if [ -f "$HOME/justfile" ]; then
  echo "Just: Moving '$HOME/justfile' to '$HOME/justfile.old'"
  mv "$HOME/justfile" "$HOME/justfile.old"
fi

echo "Just: Adding symlink - '$HOME/justfile' > '$DIR/justfile'"

ln -s "$DIR/justfile" "$HOME/justfile"
