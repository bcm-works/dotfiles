#!/usr/bin/env bash
#
#
# Setup Git
#
#

REPO="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO"
DOTFILES="/home/media/Git/dotfiles"
source "$DOTFILES/bin/.helper.sh"
OS="$(os)"
OS_CLEAN="$(os_clean)"
bash "$REPO/bin/backup.sh"

NOW=$(date "+%Y%m%d-%H%M%S")
source "$REPO/config/.env.local"

info "Git SSH key setup"

mkdir -p "$HOME/.ssh"
SSH_KEY="$HOME/.ssh/personal-$OS_CLEAN-github-$NOW"
ssh-keygen -t ed25519 -C "$DOTFILES_USER_EMAIL" -f "$SSH_KEY" -N ""
eval "$(ssh-agent -s)"
ssh-add "$SSH_KEY"

info "Git config user setup"

git config --global user.name "$DOTFILES_USER_NAME"
git config --global user.email "$DOTFILES_USER_EMAIL"

info "GitHub CLI setup"

bash "$DOTFILES/dev/git/github-cli-setup.sh"
gh auth refresh -h github.com --scopes admin:public_key,admin:ssh_signing_key

info "GitHub CLI add SSH Public Key"

gh ssh-key add "$SSH_KEY.pub" --title "Key - Personal $OS $NOW"
gh ssh-key add "$SSH_KEY.pub" --type signing --title "Signing - Personal $OS $NOW"

info "Git setup script using SSH Public Key"

export SSH_PUBLIC_KEY_PATH="$SSH_KEY.pub" && bash "$DOTFILES/dev/git/git-setup.sh"

