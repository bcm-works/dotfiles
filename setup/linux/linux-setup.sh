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

warn 'Linux Setup: Requesting sudo access'
sudo -v

info 'Linux Setup: Run setup/linux/bash/bash-setup.sh'
bash "$REPO/setup/linux/bash/bash-setup.sh"

info 'Linux Setup: Run setup/linux/packages/fzf.sh'
bash "$REPO/setup/linux/packages/fzf.sh"

info 'Linux Setup: Run fonts/fonts-setup.sh'
bash "$REPO/fonts/fonts-setup.sh"

info 'Linux Setup: Run dev/git/git-setup.sh'
bash "$REPO/dev/git/git-setup.sh"

info 'Linux Setup: Run setup/linux/packages/flatpak.sh'
bash "$REPO/setup/linux/packages/flatpak.sh"

info 'Linux Setup: Run setup/linux/distros/endeavouros.sh'
bash "$REPO/setup/linux/distros/endeavouros.sh"

info 'Linux Setup: Run setup/linux/distros/debian.sh'
bash "$REPO/setup/linux/distros/debian.sh"

info 'Linux Setup: Run setup/linux/distros/fedora.sh'
bash "$REPO/setup/linux/distros/fedora.sh"

info 'Linux Setup: Run setup/linux/distros/ubuntu.sh'
bash "$REPO/setup/linux/distros/ubuntu.sh"

info 'Linux Setup: Run setup/linux/distros/mint.sh'
bash "$REPO/setup/linux/distros/mint.sh"

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

info 'Linux Setup: Finished, a system reboot is recommended'
