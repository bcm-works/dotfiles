#!/usr/bin/env bash
#
#
# Deno setup
# 	- More info at https://deno.com/
# 	- Install commands from https://docs.deno.com/runtime/getting_started/installation/
#   - Dx alias setup command from https://docs.deno.com/runtime/reference/cli/x/
#   - To run this script:
#     - Clone this repo
#     - Open that dir in a new terminal
#     - Run: bash ./bin/setup.sh
#     - Run: bash ./dev/deno-setup.sh
#
#

source "$HOME/Dotfiles/bin/utils.sh"
REPO="$(dir_repo)"
OS="$(os)"
cd "$REPO"

if [[ "$OS" == "Windows" ]]; then
  error 'Please install Deno for Windows manually - https://deno.com/'
  exit 1
elif [[ "$OS" == "macOS" ]]; then
  info 'Installing Deno for macOS'

  curl -fsSL https://deno.land/install.sh | sh
else
  info 'Installing Deno for Linux'

  curl -fsSL https://deno.land/install.sh | sh
fi

info "Install the 'dx' alias for 'deno x'"

deno x --install-alias

success 'Deno installed'
