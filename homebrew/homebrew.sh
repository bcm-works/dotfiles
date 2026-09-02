#!/usr/bin/env bash
#
#
# Homebrew installer helper
#   - Based on docs from https://brew.sh/ and https://docs.brew.sh/Homebrew-on-Linux
#
#

source "$HOME/Dotfiles/bin/utils.sh"
REPO="$(dir_repo)"
OS="$(os)"
cd "$REPO"

if [[ "$OS" == "Windows" ]]; then
  error 'This script requires Linux or macOS.'
  exit 0
elif [[ "$OS" == "Linux" ]]; then
  warn 'Homebrew: Requesting sudo'
  sudo -v
fi

if command -v brew > /dev/null 2>&1 ; then
  success 'Homebrew already installed'
else
  warn 'Install Homebrew to the default location?'
  read -n 1 -rp '  [y/N] > ' BREW_DEFAULT
  if [[ "$BREW_DEFAULT" == "y" ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    echo ''
    warn 'Install Homebrew to ~/.brew instead?'
    read -n 1 -rp '  [y/N] > ' BREW_USER
    if [[ "$BREW_USER" == "y" ]]; then
      echo ''
      if [[ "$OS" == "macOS" ]]; then
        bash "$REPO/homebrew/homebrew.user.macos.sh"
      else
        bash "$REPO/homebrew/homebrew.user.linux.sh"
      fi
    else
      echo ''
      error 'Homebrew is required for various scripts.'
      exit 1
    fi
  fi
fi

warn 'Reloading shell to apply changes'
source "$HOME/.bashrc"

info 'Installing Bold Brew (bbrew)'
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Valkyrie00/bold-brew/main/install.sh)" > /dev/null 2>&1

PACKAGES_LIST="$REPO/config/packages/homebrew.list.txt"
if [ -f "$PACKAGES_LIST" ]; then
  info "Processing Homebrew packages from '$PACKAGES_LIST'"

  while read -r package; do
  	info "  Installing $package"
    brew install -y "$package" > /dev/null 2>&1
    brew upgrade -y "$package" > /dev/null 2>&1
  done < "$PACKAGES_LIST"
fi
