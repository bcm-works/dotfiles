#!/usr/bin/env bash
#
#
# Linux: Setup system
#
#

REPO="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO"
source "$REPO/bin/utils.sh"
OS="$(os)"

if [[ "$OS" == "macOS" ]] || [[ "$OS" == "Windows" ]]; then
  echo "This script requires Linux."
  exit 0
fi

info 'Linux Setup: Requesting sudo access'
sudo -v

info 'Linux Setup: Run setup/linux/bash/bash-setup.sh'
bash "$REPO/setup/linux/bash/bash-setup.sh"

info 'Linux Setup: Run setup/linux/linux-fzf.sh'
bash "$REPO/setup/linux/linux-fzf.sh"

info 'Linux Setup: Run fonts/fonts-setup.sh'
bash "$REPO/fonts/fonts-setup.sh"

info 'Linux Setup: Run dev/git/git-setup.sh'
bash "$REPO/dev/git/git-setup.sh"

info 'Linux Setup: Run setup/linux/packages/linux-flatpak.sh'
bash "$REPO/setup/linux/packages/linux-flatpak.sh"

info 'Linux Setup: Run setup/linux/distros/linux-endeavouros.sh'
bash "$REPO/setup/linux/distros/linux-endeavouros.sh"

info 'Linux Setup: Run setup/linux/distros/linux-debian.sh'
bash "$REPO/setup/linux/distros/linux-debian.sh"

info 'Linux Setup: Run setup/linux/distros/linux-fedora.sh'
bash "$REPO/setup/linux/distros/linux-fedora.sh"

info 'Linux Setup: Run setup/linux/distros/linux-ubuntu.sh'
bash "$REPO/setup/linux/distros/linux-ubuntu.sh"

info 'Linux Setup: Run setup/linux/distros/linux-mint.sh'
bash "$REPO/setup/linux/distros/linux-mint.sh"

info 'Linux Setup: Run setup/linux/hardware/keychron-keyboards.sh'
bash "$REPO/setup/linux/hardware/keychron-keyboards.sh"

info 'Linux Setup: Run setup/linux/hardware/bluetooth-fixes.sh'
bash "$REPO/setup/linux/hardware/bluetooth-fixes.sh"

info 'Linux Setup: Run homebrew/homebrew-setup-user.linux.sh'
bash "$REPO/homebrew/homebrew-setup-user.linux.sh"

info 'Linux Setup: Run just/just-setup.sh'
bash "$REPO/just/just-setup.sh"

info 'Linux Setup: Run setup/linux/vim/vim.sh'
bash "$REPO/setup/linux/vim/vim.sh"

info 'Linux Setup: Run setup/linux/packages/linux-google-chrome.sh'
bash "$REPO/setup/linux/packages/linux-google-chrome.sh"

info 'Linux Setup: Finished, a system reboot is recommended'
