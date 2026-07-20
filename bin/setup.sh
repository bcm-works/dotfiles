#!/usr/bin/env bash
#
#
# Interactive setup script
#
#

REPO="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO"
source "$REPO/bin/utils.sh"
OS="$(os)"

if [[ "$OS" == "Windows" ]]; then
  error 'These scripts require either Linux or macOS.'
  exit 1
fi

warn 'The scripts used here will make changes to your system.'
warn 'Please review the content of the scripts before running them.'
warn 'Continue?'

read -n 1 -rp '  [y/N] > ' CONTINUE_SETUP
if [[ "$CONTINUE_SETUP" != "y" ]]; then
  info 'Cancelled'
  exit 0
fi

echo ''
bash "$REPO/bin/backup-config.sh"

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
		exit 1
	fi
else
	if [ -d "$REPO/config" ]; then
		warn "File not found at '$REPO/.env', using '$REPO/config' for config"
	else
		error "File not found at '$REPO/.env' and '$REPO/config' does not exist."
		exit 1
	fi
fi

if [ ! -d "$HOME/Dotfiles" ]; then
  success "Setup symlink: '$HOME/Dotfiles' > '$REPO'"
  ln -s "$REPO" "$HOME/Dotfiles"
else
  warn "Skipped symlink, '$HOME/Dotfiles' already exists"
fi

if command -v brew > /dev/null 2>&1 ; then
  warn 'Homebrew package manager already installed'
else
  info 'Homebrew package manager setup'

  warn 'Install Homebrew to the default location?'
  read -n 1 -rp '  [y/N] > ' BREW_DEFAULT
  if [[ "$BREW_DEFAULT" == "y" ]]; then
    bash "$REPO/setup/homebrew/homebrew-setup.sh"
  else
    echo ''
    warn 'Install Homebrew to the default location?'
    read -n 1 -rp '  [y/N] > ' BREW_USER
    if [[ "$BREW_USER" == "y" ]]; then
      echo ''
      if [[ "$OS" == "macOS" ]]; then
        bash "$REPO/setup/homebrew/homebrew-setup-user.macos.sh"
      else
        bash "$REPO/setup/homebrew/homebrew-setup-user.linux.sh"
      fi
    else
    	echo ''
      error 'Homebrew is required for various scripts'
      exit 1
    fi
  fi
fi

info 'Just command runner setup'

bash "$REPO/setup/just/just-setup.sh"

success 'Base tools install completed.'
success 'Now you can run the setup scripts that suit your needs.'
