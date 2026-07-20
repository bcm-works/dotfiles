#!/usr/bin/env bash
#
#
# GitHub CLI: Install and login
#   - More info at https://cli.github.com/
#
#

DIR="$(cd "$(dirname "$0")" && pwd)"

REPO="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$REPO"
source "$REPO/bin/utils.sh"
OS="$(os)"
BIN="$REPO/bin"

if [[ "$OS" == "Windows" ]]; then
  echo "Requires Linux or macOS"
  exit 1
fi

# Install and configure GitHub CLI

brew reinstall gh

gh auth login --git-protocol ssh --skip-ssh-key --web

gh auth setup-git --hostname github.com

gh config set git_protocol ssh
gh config set editor vim
gh config set color_labels enabled
