#!/usr/bin/env bash
#
#
# Lore version control setup - https://lore.org/
#
#

REPO="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$REPO"
source "$REPO/bin/utils.sh"
OS="$(os)"

info "Installing Lore"
# From https://epicgames.github.io/lore/how-to/install-lore-cli/#install-the-prebuilt-binary
curl -fsSL https://raw.githubusercontent.com/EpicGames/lore/main/scripts/install.sh | bash

info "Installing Lore server"
# From https://epicgames.github.io/lore/how-to/deploy-local-lore-server/
curl -fsSL https://raw.githubusercontent.com/EpicGames/lore/main/scripts/install.sh | bash -s -- --server

info "Loading '$HOME/.bashrc' to apply changes to this session"
source "$HOME/.bashrc"

info "Installing Lore shell completions for Bash"
# From https://epicgames.github.io/lore/how-to/install-lore-cli/#install-shell-completions-optional
mkdir -p "$HOME/.local/share/bash-completion/completions"
lore completions bash > "$HOME/.local/share/bash-completion/completions/lore"

info "Requesting sudo for Lore server config setup"
# From https://epicgames.github.io/lore/how-to/deploy-local-lore-server/
sudo -v

info "Creating Lore server config directories"
sudo mkdir -p /home/loreserver/{certs,config,store}

info "Copying over Lore server config"
sudo cp "$REPO/setup/dev/lore/server-config.toml" /home/loreserver/config/local.toml

info "Generating local self-signed certificates"
openssl req -x509 -newkey rsa:2048 -nodes \
  -keyout /home/loreserver/certs/key.pem \
  -out /home/loreserver/certs/cert.pem \
  -days 365 -subj "/CN=localhost" -addext "subjectAltName=IP:127.0.0.1,DNS:localhost" > /dev/null 2>&1

info "Setting owner of Lore server config directories"
sudo chown -R $(id -u):$(id -g) /home/loreserver

success "Finished, try running 'lore' or 'loreserver --config /home/loreserver/config'"
