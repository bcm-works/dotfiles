#!/usr/bin/env bash
#
#
# Python setup
#   - To run this script:
#     - Clone this repo
#     - Open that dir in Terminal
#     - Run: bash ./dev/python-setup.sh
#
#

source "$HOME/Dotfiles/bin/utils.sh"
REPO="$(dir_repo)"
OS="$(os)"
cd "$REPO"

if [ ! "$(os_debian_based)" ]; then
  error 'Please install Python 3 manually - https://www.python.org/downloads/'
  exit 1
fi

warn "Requesting sudo"
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

if [ "$(command -v uv)" ]; then
	success "UV already installed"
else
	info "Installing UV"
	# From https://docs.astral.sh/uv/getting-started/installation/
	curl -LsSf https://astral.sh/uv/install.sh | sh
fi

warn 'Reloading shell to apply changes'
source "$HOME/.bashrc"

success "Python 3 should be ready to go"
