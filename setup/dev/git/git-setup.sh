#!/usr/bin/env bash
#
#
# Git: Install addons, set global Git config and add Git aliases
#
#

REPO="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$REPO"
source "$REPO/bin/utils.sh"
OS="$(os)"

info "Setup Git Bash features"

bash "$REPO/setup/dev/git/git-bash-setup.sh"

info "Set global Git Config"

git config --global init.defaultBranch "main"
git config --global push.default "simple"
git config --global push.followtags "false"
git config --global push.autosetupremote "true"
git config --global merge.ff "only"
git config --global pull.ff "only"
git config --global merge.commit no
git config --global merge.ff no

git config --global core.whitespace "fix,-indent-with-non-tab,trailing-space,cr-at-eol"
git config --global core.ignorecase "false"
git config --global core.symlinks "true"

git config --global color.ui "true"

git config --global color.branch.current "green"
git config --global color.branch.local "blue"
git config --global color.branch.remote "red"

git config --global color.diff.meta "yellow"
git config --global color.diff.frag "magenta"
git config --global color.diff.old "red bold"
git config --global color.diff.new "green"
git config --global color.diff.whitespace "red reverse"

git config --global color.status.added "green"
git config --global color.status.changed "yellow"
git config --global color.status.untracked "red"

info "Add Git aliases"

git config --global alias.f "fetch"
git config --global alias.st "status --untracked-files=all --short --branch"
git config --global alias.co "checkout"
git config --global alias.ci "commit"
git config --global alias.cia "commit --amend"
git config --global alias.br "branch --show-current"
git config --global alias.cbr "checkout -b"
git config --global alias.lg "log --pretty=format:'%Cblue%h%Creset %s %Cgreen%an, %cr %Creset' --abbrev-commit --date=relative"
git config --global alias.graph "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"

if [ -n "$SSH_PUBLIC_KEY_PATH" ]; then
	info "Configuring commit signing for '$SSH_PUBLIC_KEY_PATH'"

	touch $HOME/.ssh/allowed_signers

	git config --global gpg.format ssh
	git config --global commit.gpgsign true
	git config --global user.signingkey $SSH_PUBLIC_KEY_PATH
	git config --global credential.helper store
	git config --global gpg.ssh.allowedsignersfile $HOME/.ssh/allowed_signers

	echo "$(git config --get user.email) namespaces=\"git\" $(cat $SSH_PUBLIC_KEY_PATH)" >> $HOME/.ssh/allowed_signers
else
	warn "Skipping commit signing. Requires 'SSH_PUBLIC_KEY_PATH' var to be exported when running this script."
fi
