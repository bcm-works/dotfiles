#!/usr/bin/env bash
#
#
# Node setup
#   - More info about Node at https://nodejs.org/
#   - More info about NVM at https://github.com/nvm-sh/nvm
# 	- NVM install command from https://github.com/nvm-sh/nvm?tab=readme-ov-file#git-install
#   - To run this script:
#     - Clone this repo
#     - Open that dir in Terminal
#     - Run: bash ./dev/node/node-setup.sh
#
#

REPO="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$REPO"
source "$REPO/bin/utils.sh"
OS="$(os)"

if [[ "$OS" == "Windows" ]]; then
  error 'Please install Node manually - https://nodejs.org/'
  exit 1
fi

info 'Install Nub'

curl -fsSL https://nubjs.com/install.sh | bash

info 'Installing Node 26, using as the default version'

nub node install 26.5.0
echo '26.5.0' > "$HOME/.node-version"
nub node shim

info "Copying over global Node config to '$HOME/.npmrc'"

[ -f "$HOME/.npmrc" ] && cp "$HOME/.npmrc" "$HOME/.npmrc.bak"
cp "$REPO/setup/dev/node/.npmrc" "$HOME/.npmrc"

warn 'Please use a new terminal session to access Node 26, NPM and Nub.'
