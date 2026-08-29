#!/usr/bin/env bash
#
#
# Dotfiles initial setup
#
#

echo 'The scripts used here will make changes to your system.'
echo 'Please review the content of the scripts before running them.'
echo 'Continue?'
echo ''
read -n 1 -rp '[y/N] > ' CONTINUE_SETUP
if [[ "$CONTINUE_SETUP" != "y" ]]; then
  echo 'Cancelled'
  exit 1
fi

echo ''

if [ ! -d "$HOME/Dotfiles" ]; then
	REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  echo "Adding symlink: '$HOME/Dotfiles' > '$REPO'"
  ln -s "$REPO" "$HOME/Dotfiles"
else
  echo "Skipped symlink, '$HOME/Dotfiles' already exists"
fi

source "$HOME/Dotfiles/bin/utils.sh"
REPO="$(dir_repo)"
OS="$(os)"
cd "$REPO"

if [[ "$OS" == "Windows" ]]; then
  error 'These scripts require either Linux or macOS.'
  exit 1
fi

backup_config

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

info 'Ensure required config sub-directories exist'

mkdir -p "$REPO/config/backups"
mkdir -p "$REPO/config/packages"

if command -v brew > /dev/null 2>&1 ; then
  warn 'Homebrew package manager already installed'
else
  info 'Homebrew package manager setup'

  warn 'Install Homebrew to the default location?'
  read -n 1 -rp '  [y/N] > ' BREW_DEFAULT
  if [[ "$BREW_DEFAULT" == "y" ]]; then
    bash "$REPO/homebrew/homebrew-setup.sh"
  else
    echo ''
    warn 'Install Homebrew to ~/.brew instead?'
    read -n 1 -rp '  [y/N] > ' BREW_USER
    if [[ "$BREW_USER" == "y" ]]; then
      echo ''
      if [[ "$OS" == "macOS" ]]; then
        bash "$REPO/homebrew/homebrew-setup-user.macos.sh"
      else
        bash "$REPO/homebrew/homebrew-setup-user.linux.sh"
      fi
    else
    	echo ''
      error 'Homebrew is required for various scripts'
      exit 1
    fi
  fi
fi

info 'Just command runner setup'

bash "$REPO/just/just.sh"

success 'Initial setup completed.'
success 'Now you can run the setup scripts that suit your needs.'
