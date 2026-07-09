#!/usr/bin/env bash
#
#
# Linux: Debian-based distro setup
#
#

REPO="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO"
source "$REPO/bin/.helper.sh"
OS="$(os)"

if [ ! "$(os_debian_based)" ]; then
  error "This script requires a Debian-based OS."
  exit 0
fi

info "Continuing as this OS is Debian-based."
