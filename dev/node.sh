#!/usr/bin/env bash
#
#
# Node setup
#   - More info about Node at https://nodejs.org/
#   - More info about NVM at https://github.com/nvm-sh/nvm
# 	- NVM install command from https://github.com/nvm-sh/nvm?tab=readme-ov-file#git-install
#   - To run this script:
#     - Clone this repo
#     - Open that dir in a new terminal
#     - Run: bash ./bin/setup.sh
#     - Run: bash ./dev/node.sh
#
#

source "$HOME/Dotfiles/bin/utils.sh"
REPO="$(dir_repo)"
OS="$(os)"
cd "$REPO"

if [[ "$OS" == "Windows" ]]; then
  error 'Please install Node manually - https://nodejs.org/'
  exit 0
fi

info 'Setup the NVM directory'

export NVM_DIR="${HOME}/.nvm"
rm -rf "$NVM_DIR"
mkdir -p "$NVM_DIR"

info 'Install NVM'

git clone --quiet "https://github.com/nvm-sh/nvm.git" "$NVM_DIR"

info 'Load NVM'

source "$NVM_DIR/nvm.sh" > /dev/null 2>&1

info 'Installing the latest Node 26 release and setting that as the default version'

nvm install 26 > /dev/null 2>&1
nvm alias default 26 > /dev/null 2>&1

info 'Installing the latest version of NPM'

nvm install-latest-npm > /dev/null 2>&1

info 'Setup defensive default config for NPM'

npm config set --global engine-strict true
npm config set --global package-lock true
npm config set --global ignore-scripts true
npm config set --global save true
npm config set --global fund false
npm config set --global audit false
npm config set --global min-release-age 14
npm config set --global workspaces false
npm config set --global init-private true

warn 'Reloading shell to apply changes'
source "$HOME/.bashrc"

success 'Node and NPM installed'

info "Node version: $(node --version)"
info "NPM version: $(npm --version)"
