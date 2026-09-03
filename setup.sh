#!/usr/bin/env bash
#
#
# Initial setup script
#
#

echo ''
echo 'These scripts will make changes to your system packages and config.'
echo 'Review the content of the scripts before running them. Continue?'
read -n 1 -rp '[y/N] > ' CONTINUE_SETUP
if [[ "$CONTINUE_SETUP" != "y" ]]; then
  echo 'Cancelled'
  exit 0
fi

echo ''

if [ ! -d "$HOME/Dotfiles" ]; then
	REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  echo "Adding symlink: '$HOME/Dotfiles' > '$REPO'"
  ln -s "$REPO" "$HOME/Dotfiles"
else
  echo "Skipped symlink, '$HOME/Dotfiles' already exists"
fi

source "$HOME/Dotfiles/bin/utils.sh"
REPO="$(dir_repo)"
OS="$(os)"
OSC="$(os_clean)"
OSD="$(os_desktop)"
OSDC="$(os_desktop_clean)"
cd "$REPO"

if [[ "$OS" == "Windows" ]]; then
  error 'These scripts require either Linux or macOS.'
  exit 0
fi

info 'Checking for custom config dir'

if [ -f "$REPO/.env" ]; then
	source "$REPO/.env"

	if [ -d "$DOTFILES_CONFIG_DIR" ]; then
		if [ -d "$REPO/config" ]; then
			warn "Skipped symlink, '$REPO/config' already exists"
		else
			success "Setup symlink: '$DOTFILES_CONFIG_DIR' > '$REPO/config'"
			ln -s "$DOTFILES_CONFIG_DIR" "$REPO/config"
		fi
	else
		error "Custom config dir '$DOTFILES_CONFIG_DIR' does not exist"
		exit 0
	fi
else
	if [ -d "$REPO/config" ]; then
		warn "File not found at '$REPO/.env', using '$REPO/config' for config"
	else
		error "File not found at '$REPO/.env' and '$REPO/config' does not exist."
		exit 0
	fi
fi

info 'Ensure required config sub-directories exist'

mkdir -p "$REPO/config/backups"
mkdir -p "$REPO/config/packages"

backup_config

info 'Setup Bash'
bash ~/Dotfiles/linux/bash/bash.sh

info 'Add Fonts'
bash ~/Dotfiles/fonts/fonts.sh

info 'Setup Homebrew'
bash ~/Dotfiles/homebrew/homebrew.sh

info 'Setup Just'
bash ~/Dotfiles/just/just.sh

info 'Setup Git'
bash ~/Dotfiles/dev/git/git.sh

info 'Setup Flatpak'
bash ~/Dotfiles/linux/packages/flatpak.sh

info 'Setup Keychron keyboards'
bash ~/Dotfiles/linux/hardware/keychron-keyboards.sh

info 'Setup Zed'
bash ~/Dotfiles/dev/zed/zed.sh

info 'Setup Vim'
bash ~/Dotfiles/linux/vim/vim.sh

info 'Setup Node'
bash ~/Dotfiles/dev/node.sh

info 'Setup Deno'
bash ~/Dotfiles/dev/deno.sh

info 'Setup Go'
bash ~/Dotfiles/dev/go.sh

info 'Setup Chrome'
bash ~/Dotfiles/linux/packages/chrome.sh

info 'Setup Docker'
bash ~/Dotfiles/dev/docker/docker.sh

DISTRO_SETUP_SCRIPT="$REPO/linux/distros/$OSC.sh"
if [[ -f "$DISTRO_SETUP_SCRIPT" ]]; then
	warn "Running $OS setup from '$DISTRO_SETUP_SCRIPT'"
	bash "$DISTRO_SETUP_SCRIPT"
fi

DESKENV_SETUP_SCRIPT="$REPO/linux/desktop-environments/$OSDC.sh"
if [[ -f "$DESKENV_SETUP_SCRIPT" ]]; then
	warn "Running $OSD setup from '$DESKENV_SETUP_SCRIPT'"
	bash "$DESKENV_SETUP_SCRIPT"
fi

info 'Setup Symlinks'
bash ~/Dotfiles/linux/symlinks/symlinks.sh

success 'Setup script completed.'
warn 'A reboot is recommended.'
