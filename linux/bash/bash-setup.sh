#!/usr/bin/env bash
#
#
# Bash Shell: Apply customisations
#   - Makes a copy of the changed files first
#   - Then copies over the relevant files from this dir to $HOME with the right names
#
#

REPO="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO"
source "$REPO/bin/.helper.sh"
OS="$(os)"

if [[ "$OS" == "Windows" ]]; then
  error "This script requires Linux or macOS."
  exit 0
fi

info "Create a backup of '$HOME/.bashrc'"

[ -f "$HOME/.bashrc" ] && cp "$HOME/.bashrc" "$HOME/.bashrc.old"

info 'Setup Git Bash features'

bash "$REPO/dev/git/git-bash-setup.sh"

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
