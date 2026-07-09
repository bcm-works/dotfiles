#!/usr/bin/env bash
#
#
# Homebrew macOS: Install to user dir
#   - Installs Homebrew for macOS, based on docs from https://docs.brew.sh/Installation
#   - Assumes use of default ZSH shell
#   - Then moves this install '~/.brew' instead
#   - Installs the 'gcc' Homebrew package
#
#

REPO="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO"
source "$REPO/bin/.helper.sh"
OS="$(os)"

if [[ "$OS" != "macOS" ]]; then
  echo "This script requires macOS."
  exit 0
fi

BREW_DIR="$HOME/.brew"

mkdir -p "$BREW_DIR"

curl -L https://github.com/Homebrew/brew/tarball/main | tar xz --strip-components 1 -C "$BREW_DIR"

eval "$($BREW_DIR/bin/brew shellenv)"

brew update --force --quiet

chmod -R go-w "$(brew --prefix)/share/zsh"

touch "$HOME/.zshrc"

echo "BREW_DIR='$(echo $BREW_DIR)'" >> "$HOME/.zshrc"

echo 'export HOMEBREW_RELOCATE_BUILD_PREFIX="$BREW_DIR"' >> "$HOME/.zshrc"
echo 'export HOMEBREW_CELLAR="$BREW_DIR/Cellar"' >> "$HOME/.zshrc"
echo 'export HOMEBREW_PREFIX="$BREW_DIR"' >> "$HOME/.zshrc"
echo 'export HOMEBREW_NO_ENV_HINTS=1' >> "$HOME/.zshrc"
echo 'export HOMEBREW_NO_UPDATE_REPORT_FORMULAE=1' >> "$HOME/.zshrc"
echo 'export HOMEBREW_NO_UPDATE_REPORT_CASKS=1' >> "$HOME/.zshrc"

echo 'eval "$($BREW_DIR/bin/brew shellenv)"' >> "$HOME/.zshrc"
echo 'alias brew="$BREW_DIR/bin/brew"' >> "$HOME/.zshrc"

source "$HOME/.zshrc"

brew install gcc
