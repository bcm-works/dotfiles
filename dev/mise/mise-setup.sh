#!/usr/bin/env bash
#
#
# Mise setup
# 	- More info at https://mise.en.dev/
# 	- Install commands from https://mise.en.dev/installing-mise.html
#   - To run this script:
#     - Clone this repo
#     - Open that dir in Terminal
#     - Run: bash ./dev/mise/mise-setup.sh
#
#

REPO="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO"
source "$REPO/bin/.helper.sh"

if [[ "$(os)" == "Windows" ]]; then
  error 'Please install Mise manually - https://mise.en.dev/'
  exit 1
fi

info "Installing Mise"

curl https://mise.run | sh

info "Enabling Mise for this terminal session"

source "$HOME/.bashrc"
eval "$($HOME/.local/bin/mise activate bash)"

if ! command -v bash-completion > /dev/null 2>&1 ; then
  info "Installing system 'bash-completion' package"
  sudo apt -qq --assume-yes install bash-completion > /dev/null 2>&1
fi

info "Customising Mise config"

mise settings add quiet true
mise settings add env_shell_expand true
mise settings add lockfile true
mise settings add minimum_release_age 7d
mise settings add dotfiles.default_mode symlink
mise settings add dotfiles.root ~/Dotfiles
mise settings add node.nvm_dir ~/.nvm

mise settings add task.monorepo_depth 2
mise settings add task.monorepo_respect_gitignore true

mise settings add idiomatic_version_file_enable_tools npm
mise settings add idiomatic_version_file_enable_tools node
mise settings add idiomatic_version_file_enable_tools deno
mise settings add idiomatic_version_file_enable_tools python

info "Installing Bash Completions for Mise"

mkdir -p "$HOME/.local/share/bash-completion/completions"
mise completion bash --include-bash-completion-lib > "$HOME/.local/share/bash-completion/completions/mise"

success "Mise installed successfully"
