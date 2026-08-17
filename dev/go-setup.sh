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

GO_INSTALL_VERSION="1.26.6"
GO_INSTALL_DOWNLOAD="$HOME/Downloads/go$GO_INSTALL_VERSION.linux-amd64.tar.gz"
GO_INSTALL_REMOTE="https://dl.google.com/go/go$GO_INSTALL_VERSION.linux-amd64.tar.gz"

if [[ "$OS" == "macOS" || "$OS" == "Windows" ]]; then
	error 'Please install Go manually first - https://go.dev/doc/install'
  exit 1
else
	warn 'Requesting sudo'
	sudo -v

	info "Downloading and installing Go version $GO_INSTALL_VERSION"

	rm -rf "$GO_INSTALL_DOWNLOAD"
	curl --silent --show-error \
		--output "$GO_INSTALL_DOWNLOAD" \
		"$GO_INSTALL_REMOTE"

	sudo rm -rf /usr/local/go
	sudo tar -C /usr/local -xzf "$GO_INSTALL_DOWNLOAD"
	rm -rf "$GO_INSTALL_DOWNLOAD"

	export PATH=$PATH:/usr/local/go/bin

	warn 'Reloading shell to apply changes'
	source "$HOME/.bashrc"
fi

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
