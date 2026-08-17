#!/usr/bin/env bash
#
#
# Go setup
# 	- More info at https://go.dev/
#   - To run this script:
#     - Clone this repo
#     - Open that dir in a new terminal
#     - Run: bash ./bin/setup.sh
#     - Run: bash ./dev/go-setup.sh
#
#

source "$HOME/Dotfiles/bin/utils.sh"
REPO="$(dir_repo)"
OS="$(os)"
cd "$REPO"

if [ ! "$(command -v go)" ]; then
	if [[ "$(os_debian_based)" ]]; then
	  info 'Installing Go from APT'
	  sudo apt -qq --assume-yes install golang-go > /dev/null 2>&1
	else
		error 'Please install Go manually first - https://go.dev/doc/install'
	  exit 1
	fi
fi

GO_PATH="$HOME/Code"

info "Setting GOPATH to $GO_PATH"
mkdir -p "$GO_PATH"
export GOPATH="$GO_PATH"

info 'Configuring Go'
go env -w GOPROXY="https://proxy.golang.org,direct"
go env -w GOSUMDB="sum.golang.org"

info 'Installing Go version 1.26.6'
go install golang.org/dl/go1.26.6@latest > /dev/null 2>&1
go1.26.6 download > /dev/null 2>&1

warn 'Reloading shell to apply changes'
source "$HOME/.bashrc"

success "Go installed"
info "Version: $(go version)"
info "Location: $(which go)"
