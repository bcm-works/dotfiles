#!/usr/bin/env bash
#
#
# Rust setup
# 	- More info at https://rust-lang.org/
# 	- Install commands from https://rust-lang.org/tools/install/
#   - To run this script:
#     - Clone this repo
#     - Open that dir in a new terminal
#     - Run: bash ./bin/setup.sh
#     - Run: bash ./dev/rust.sh
#
#

source "$HOME/Dotfiles/bin/utils.sh"
REPO="$(dir_repo)"
OS="$(os)"
cd "$REPO"

if [[ "$(os)" == "Windows" ]]; then
  error 'Please install Rust manually - https://rust-lang.org/tools/install/'
  exit 0
fi

info "Installing Rust"

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

warn 'Reloading shell to apply changes'
source "$HOME/.bashrc"

success "Rust installed successfully"
