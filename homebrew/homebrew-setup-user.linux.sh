#!/usr/bin/env bash
#
#
# Homebrew Linux: Install to user dir
#   - Installs Homebrew for Linux, based on docs from https://docs.brew.sh/Homebrew-on-Linux
#   - Assumes use of the Bash Shell
#   - Then moves this install '~/.brew' instead
#
#

source "$HOME/Dotfiles/bin/utils.sh"
REPO="$(dir_repo)"
OS="$(os)"
cd "$REPO"

if [[ "$OS" == "macOS" || "$OS" == "Windows" ]]; then
  echo "This script requires Linux."
  exit 0
fi

BREW_DIR_DEFAULT='/home/linuxbrew'
BREW_DIR="$HOME/.brew"

warn "Requesting sudo"
sudo -v
if [ $? -ne 0 ]; then
  echo "Request for sudo privileges failed, exiting"
  exit 0
fi

sudo rm -rf "$BREW_DIR_DEFAULT/.linuxbrew"
sudo rm -rf "$BREW_DIR"

bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

sudo mv "$BREW_DIR_DEFAULT/.linuxbrew" "$BREW_DIR"
sudo chown -R "$USER:$USER" "$BREW_DIR"
sudo rm -rf "$BREW_DIR_DEFAULT"

warn 'Reloading shell to apply changes'
source "$HOME/.bashrc"

eval "$($BREW_DIR/bin/brew shellenv bash)"

echo 'Installing GCC via Homebrew'

brew install gcc > /dev/null 2>&1

if [[ "$OS" == "Fedora" ]]; then
  echo 'Fedora: Installing development-tools package'
  sudo dnf group install -y development-tools > /dev/null 2>&1
fi

echo 'Installing Bold Brew (bbrew)'
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Valkyrie00/bold-brew/main/install.sh)" > /dev/null 2>&1
