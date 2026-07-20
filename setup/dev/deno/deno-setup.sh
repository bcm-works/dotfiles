#!/usr/bin/env bash
#
#
# Deno setup
# 	- More info at https://deno.com/
# 	- Install commands from https://docs.deno.com/runtime/getting_started/installation/
#   - Dx alias setup command from https://docs.deno.com/runtime/reference/cli/x/
#   - To run this script:
#     - Clone this repo
#     - Open that dir in Terminal
#     - Run: bash ./dev/deno/deno-setup.sh
#
#

REPO="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$REPO"
source "$REPO/bin/utils.sh"
OS="$(os)"

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
