#!/usr/bin/env bash
#
#
# Rust setup
# 	- More info at https://rust-lang.org/
# 	- Install commands from https://rust-lang.org/tools/install/
#   - To run this script:
#     - Clone this repo
#     - Open that dir in Terminal
#     - Run: bash ./dev/rust/rust-setup.sh
#
#

REPO="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$REPO"
source "$REPO/bin/utils.sh"

if [[ "$(os)" == "Windows" ]]; then
  error 'Please install Rust manually - https://rust-lang.org/tools/install/'
  exit 1
fi

info "Installing Rust"

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

info "Reloading '$HOME/.bashrc' to apply changes to this session"

source "$HOME/.bashrc"

success "Rust installed successfully"
