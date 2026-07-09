#!/usr/bin/env bash
#
#
# Dev setup
#
#

REPO="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO"
source "$REPO/bin/.helper.sh"
OS="$(os)"

if [[ "$OS" == "Windows" ]] | [[ "$OS" == "macOS" ]]; then
  error 'This script requires Linux';
  exit 1
fi

warn 'Requesting sudo'

sudo -v

info 'Run: dev/node/node-setup.sh'
bash "$REPO/dev/node/node-setup.sh"

info 'Run: dev/deno/deno-setup.sh'
bash "$REPO/dev/deno/deno-setup.sh"

info 'Run: dev/python/python-setup.sh'
bash "$REPO/dev/python/python-setup.sh"

info 'Run: dev/rust/rust-setup.sh'
bash "$REPO/dev/rust/rust-setup.sh"

if grep -q "127.0.0.1 site.local" "/etc/hosts"; then
	success "Found current setup for 'site.local' as an alias for 'localhost'"
else
	info "Adding 'site.local' as an alias for 'localhost'"

	echo "127.0.0.1 site.local" | sudo tee -a "/etc/hosts" > /dev/null
	sudo systemctl restart systemd-resolved
fi
