#!/usr/bin/env bash
#
#
# Go setup
# 	- More info at https://go.dev/
# 	- Install commands from https://go.dev/doc/install
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

GO_PATH="$HOME/Code"
GO_DOWNLOAD="$HOME/Downloads/go1.26.6.linux-amd64.tar.gz"

if [ ! "$(command -v go)" ]; then
	if [[ "$OS" == "macOS" || "$OS" == "Windows" ]]; then
		error 'Please install Go manually first - https://go.dev/doc/install'
	  exit 1
	else
		warn 'Requesting sudo'
		sudo -v

		info 'Downloading and installing Go version 1.26.6'

		rm -rf "$GO_DOWNLOAD"
		curl --silent --show-error \
			--output "$GO_DOWNLOAD" \
			"https://dl.google.com/go/go1.26.6.linux-amd64.tar.gz"

		sudo rm -rf /usr/local/go
		sudo tar -C /usr/local -xzf "$GO_DOWNLOAD"

		export PATH=$PATH:/usr/local/go/bin
	fi
fi

warn 'Reloading shell to apply changes'
source "$HOME/.bashrc"

info "Setting GOPATH to $GO_PATH"
mkdir -p "$GO_PATH"
export GOPATH="$GO_PATH"

info 'Configuring Go'
go env -w GOPROXY="https://proxy.golang.org,direct"
go env -w GOSUMDB="sum.golang.org"

success "Go installed"

info "Go Version: $(go version)"
info "Go Binary: $(which go)"
info "Go Root: $(go env GOROOT)"
info "Go Path: $(go env GOPATH)"
