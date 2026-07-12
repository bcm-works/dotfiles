#!/usr/bin/env bash
#
#
# Git: Setup Bash prompt and Git Branch autocomplete
#
#

REPO="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO"
source "$REPO/bin/.helper.sh"
OS="$(os)"

if [[ "$OS" == "Ubuntu" ]]; then
  info 'Ubuntu: Install Git and Curl'
  sudo apt update -qq > /dev/null 2>&1
  sudo apt -qq --assume-yes install git curl > /dev/null 2>&1
fi

info 'Download the Git Prompt script from the official Git Repo to ~/.git_bash_prompt.sh'
info 'When in a Git directory, this gets details about the status of the Repo.'

if [ -f "$HOME/.git_bash_prompt.sh" ]; then
	mv "$HOME/.git_bash_prompt.sh" "$HOME/.git_bash_prompt.sh.old"
fi

touch "$HOME/.git_bash_prompt.sh"
curl \
  --output "$HOME/.git_bash_prompt.sh" \
  "https://raw.githubusercontent.com/git/git/refs/heads/master/contrib/completion/git-prompt.sh" \
   > /dev/null 2>&1

info 'Download the Git Completion script from the official Git Repo to ~/.git_bash_autocomplete.sh'
info 'When in a Git directory, this adds auto complete for Git Branches.'

if [ -f "$HOME/.git_bash_autocomplete.sh" ]; then
	mv "$HOME/.git_bash_autocomplete.sh" "$HOME/.git_bash_autocomplete.sh.old"
fi

touch "$HOME/.git_bash_autocomplete.sh"
curl \
  --output "$HOME/.git_bash_autocomplete.sh" \
  "https://raw.githubusercontent.com/git/git/refs/heads/master/contrib/completion/git-completion.bash" \
   > /dev/null 2>&1
