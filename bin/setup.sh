#!/usr/bin/env bash
#
#
# Interactive setup script
#
#

REPO="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO"
source "$REPO/bin/.helper.sh"
OS="$(os)"

if [[ "$OS" == "Windows" ]]; then
  error 'These scripts require either Linux or macOS.'
  exit 1
fi

warn 'The scripts used here will make changes to your system.'
warn 'Please review the content of the scripts before running them.'
warn 'Continue?'

read -n 1 -rp '  [y/N] > ' CONTINUE_SETUP
if [[ "$CONTINUE_SETUP" != "y" ]]; then
  info 'Cancelled'
  exit 0
fi

echo ''

if [ ! -d "$HOME/Dotfiles" ]; then
  info "Setup symlink: '$HOME/Dotfiles' > '$REPO_REPO'"
  ln -s "$REPO_REPO" "$HOME/Dotfiles"
else
  warn "Skipped symlink, '$HOME/Dotfiles' already exists"
fi

if command -v brew > /dev/null 2>&1 ; then
  warn 'Homebrew package manager already installed'
else
  info 'Homebrew package manager setup'

  warn 'Install Homebrew to the default location?'
  read -n 1 -rp '  [y/N] > ' BREW_DEFAULT
  if [[ "$BREW_DEFAULT" == "y" ]]; then
    bash "$REPO/homebrew/homebrew-setup.sh"
  else
    echo ''
    warn 'Install Homebrew to the default location?'
    read -n 1 -rp '  [y/N] > ' BREW_USER
    if [[ "$BREW_USER" == "y" ]]; then
      echo ''
      if [[ "$OS" == "macOS" ]]; then
        bash "$REPO/homebrew/homebrew-setup-user.macos.sh"
      else
        bash "$REPO/homebrew/homebrew-setup-user.linux.sh"
      fi
    else
      echo ''
      error 'Homebrew is required for various scripts'
      exit 1
    fi
  fi
fi

info 'Just command runner setup'

bash "$REPO/just/just-setup.sh"

info 'Base tools install completed.'
info 'Now you can run the setup scripts that suit your needs.'
