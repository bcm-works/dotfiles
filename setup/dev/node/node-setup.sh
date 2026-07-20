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

info 'Setup the NVM directory'

export NVM_DIR="${HOME}/.nvm"
rm -rf "$NVM_DIR"
mkdir -p "$NVM_DIR"

info 'Install NVM'

git clone --quiet "https://github.com/nvm-sh/nvm.git" "$NVM_DIR"

info 'Load NVM'

source "$NVM_DIR/nvm.sh" > /dev/null 2>&1

info 'Installing Node v26 as the default version'

nvm install 26 > /dev/null 2>&1
nvm alias default 26 > /dev/null 2>&1

info 'Installing the latest version of NPM'

nvm install-latest-npm > /dev/null 2>&1

info 'Setup defensive default config for local NPM use'

npm config set --global engine-strict=true
npm config set --global package-lock=true
npm config set --global ignore-scripts=true
npm config set --global save=true
npm config set --global fund=false
npm config set --global audit=false

success 'Node 26 and NPM installed'
