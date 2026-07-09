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
  echo 'Ubuntu: Install Git and Curl'
  sudo apt update -qq
  sudo apt -qq --assume-yes install git curl
fi

echo 'Download the Git Prompt script from the official Git Repo to ~/.git_bash_prompt.sh'
echo 'When in a Git directory, this gets details about the status of the Repo.'

touch "$HOME/.git_bash_prompt.sh"
cp "$HOME/.git_bash_prompt.sh" "$HOME/.git_bash_prompt.sh.old"
curl \
  --output "$HOME/.git_bash_prompt.sh" \
  "https://raw.githubusercontent.com/git/git/refs/heads/master/contrib/completion/git-prompt.sh" \
   > /dev/null 2>&1

echo 'Download the Git Completion script from the official Git Repo to ~/.git_bash_autocomplete.sh'
echo 'When in a Git directory, this adds auto complete for Git Branches.'

touch "$HOME/.git_bash_autocomplete.sh"
cp "$HOME/.git_bash_autocomplete.sh" "$HOME/.git_bash_autocomplete.sh.old"
curl \
  --output "$HOME/.git_bash_autocomplete.sh" \
  "https://raw.githubusercontent.com/git/git/refs/heads/master/contrib/completion/git-completion.bash" \
   > /dev/null 2>&1
