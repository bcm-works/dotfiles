#!/usr/bin/env bash
#
#
# Linux: Force APT package upgrades in Ubuntu 26.04
#
#

source "$HOME/Dotfiles/utils.sh"
REPO="$(dir_repo)"
OS="$(os)"
cd "$REPO"

if [[ "$OS" != "Ubuntu" ]]; then
  error 'This script requires Ubuntu.'
  exit 0
fi

if ! command -v apt > /dev/null 2>&1 ; then
	error 'This script requires APT.'
	exit 0
fi

warn 'Force APT packages upgrades, even if they are in the phasing stage?'
read -n 1 -rp '  [y/N] > ' CONTINUE
if [[ "$CONTINUE" != "y" ]]; then
	warn 'Cancelled'.
	exit 0
fi

warn 'Requesting sudo'
sudo -v

info 'Updating APT packages list'
sudo apt update -qq > /dev/null 2>&1;

info 'Starting package upgrades'
sudo apt upgrade -y -qq -o APT::Get::Always-Include-Phased-Updates=true > /dev/null 2>&1;
