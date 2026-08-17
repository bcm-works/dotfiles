#!/usr/bin/env bash
#
#
# GitHub setup
# 	- Requires Homebrew - https://brew.sh/
#   - Installs the GitHub CLI - https://cli.github.com/
#   - Prompts user login, attempts to create a new SSH key and upload it to GitHub
#
#

DIR="$(cd "$(dirname "$0")" && pwd)"

REPO="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$REPO"
source "$REPO/bin/utils.sh"
OS="$(os)"
OS_CLEAN="$(os_clean)"
BIN="$REPO/bin"
NOW=$(date "+%Y%m%d-%H%M%S")

if [[ "$OS" == "Windows" ]]; then
  echo "Requires Linux or macOS"
  exit 1
fi

# Install and configure GitHub CLI

brew reinstall gh

gh auth login \
	--web --clipboard \
	--git-protocol ssh \
	--skip-ssh-key \
	--hostname github.com \
	--scopes gist,read:org,repo,read:packages

gh auth setup-git --hostname github.com
gh config set git_protocol ssh
gh config set editor vim
gh config set color_labels enabled

if [ -f "$REPO/.env" ]; then
	source "$REPO/.env"
fi

if [[ -n "$DOTFILES_USER_EMAIL" && -n "$DOTFILES_USER_NAME" ]]; then
	info "Generate new SSH key"

	mkdir -p "$HOME/.ssh"
	SSH_KEY="$HOME/.ssh/github-$OS_CLEAN-$NOW"
	ssh-keygen -t ed25519 -C "$DOTFILES_USER_EMAIL" -f "$SSH_KEY" -N ""

	info "Configure SSH to autoload the new SSH key"

	echo "Host github.com" >> "$HOME/.ssh/config"
	echo "  AddKeysToAgent yes" >> "$HOME/.ssh/config"
	echo "  IdentityFile $SSH_KEY" >> "$HOME/.ssh/config"

	echo '' >> "$HOME/.bashrc"
	echo '# SSH key setup' >> "$HOME/.bashrc"

	if [[ "$OS" == "EndeavourOS" ]]; then
		echo 'export SSH_AUTH_SOCK="/usr/lib/systemd/user/ssh-agent.socket"' >> "$HOME/.bashrc"
	fi

	echo 'eval "$(ssh-agent -s)" > /dev/null 2>&1' >> "$HOME/.bashrc"
	echo "ssh-add $SSH_KEY > /dev/null 2>&1" >> "$HOME/.bashrc"

	info "Load the SSH key in to this session"

	eval "$(ssh-agent -s)"
	ssh-add "$SSH_KEY"

	info "Git config user setup"

	git config --global user.name "$DOTFILES_USER_NAME"
	git config --global user.email "$DOTFILES_USER_EMAIL"

	info "GitHub CLI setup"

	gh auth refresh \
		--clipboard \
		--hostname github.com \
		--scopes admin:public_key,admin:ssh_signing_key

	info "GitHub CLI add SSH Public Key"

	gh ssh-key add "$SSH_KEY.pub" --title "Key - $OS $NOW"
	gh ssh-key add "$SSH_KEY.pub" --type signing --title "Signing - $OS $NOW"

	info "Configuring commit signing for '$SSH_KEY.pub'"

	touch $HOME/.ssh/allowed_signers

	git config --global gpg.format ssh
	git config --global commit.gpgsign true
	git config --global user.signingkey $SSH_KEY.pub
	git config --global credential.helper store
	git config --global gpg.ssh.allowedsignersfile $HOME/.ssh/allowed_signers

	echo "$(git config --get user.email) namespaces=\"git\" $(cat $SSH_KEY.pub)" >> $HOME/.ssh/allowed_signers
else
	warn "Skipping SSH key setup, 'DOTFILES_USER_EMAIL' and 'DOTFILES_USER_NAME' must be set."
fi
