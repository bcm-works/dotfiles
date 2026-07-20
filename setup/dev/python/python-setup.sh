#!/usr/bin/env bash
#
#
# Python setup
#   - To run this script:
#     - Clone this repo
#     - Open that dir in Terminal
#     - Run: bash ./dev/python/python-setup.sh
#
#

REPO="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$REPO"
source "$REPO/bin/utils.sh"

if [ ! "$(os_debian_based)" ]; then
  error 'Please install Python 3 manually - https://www.python.org/downloads/'
  exit 1
fi

info "Requesting sudo"

sudo -v

info "Installing packages"

sudo apt install -qq --assume-yes \
	python3 \
	python-is-python3 \
	python3-exifread \
	python3-dotenv \
	python3-gpg \
	pipx > /dev/null 2>&1

info "Running 'pipx ensurepath'"

pipx ensurepath > /dev/null 2>&1

info "Reloading '$HOME/.bashrc' to apply changes to this session"

source "$HOME/.bashrc"

success "Python 3 should be ready to go"
