#!/usr/bin/env bash
#
#
# Bash Shell: Apply customisations
#   - Makes a copy of the changed files first
#   - Then copies over the relevant files from this dir to $HOME with the right names
#
#

source "$HOME/Dotfiles/bin/utils.sh"
REPO="$(dir_repo)"
OS="$(os)"
cd "$REPO"

if [[ "$OS" == "Windows" ]]; then
  error "This script requires Linux or macOS."
  exit 0
fi

backup_config

info 'Setup Git Bash features'

bash "$REPO/dev/git/git-bash.sh"

info 'Add symlink to the customised Bash config file'

[ -f "$HOME/.bash_profile" ] && mv "$HOME/.bash_profile" "$HOME/.bash_profile.old"
chmod +x "$REPO/linux/bash/bash_profile"
ln -s "$REPO/linux/bash/bash_profile" "$HOME/.bash_profile"

info "Load the customised Bash config files at the end of '$HOME/.bashrc'"

echo '' >> "$HOME/.bashrc"
echo '# Load customised Bash config, prompt and aliases' >> "$HOME/.bashrc"
echo '. ~/.bash_profile' >> "$HOME/.bashrc"

source "$HOME/.bashrc"

success 'Future terminal sessions will automatically load the customised Bash config file'
