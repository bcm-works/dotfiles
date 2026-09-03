#!/usr/bin/env bash
#
#
# Linux - Setup symlinks from a list file
#   - Expects an empty new line at the end of the list file
#   - Supports expanding of '~' to '$HOME'
#   - List file line format: /home/example/source/path > ~/ExampleLinkDir
#
#

source "$HOME/Dotfiles/bin/utils.sh"
REPO="$(dir_repo)"
DIR="$(dir_this)"
OS="$(os)"
cd "$REPO"

LIST_FILE="$REPO/config/symlinks.list.txt"
EXAMPLE_FILE="$DIR/symlinks.example.list.txt"

USER_NAME="$(id -u)"
GROUP_NAME="$(id -g)"

if [[ "$OS" == "macOS" ]] || [[ "$OS" == "Windows" ]]; then
	error "The Symlink script requires Linux."
	exit 0
fi

if [[ ! -f "$LIST_FILE" ]]; then
	error "Symlink list file not found at '$LIST_FILE'"
	info "Review the example file at '$EXAMPLE_FILE'"
	exit 0
fi

warn "Symlink list file found at '$LIST_FILE'."
warn "Would you like to create those symlinks on this system now?"
read -n 1 -rp '  [y/N] > ' BREW_DEFAULT
if [[ "$BREW_DEFAULT" != "y" ]]; then
	echo ''
	warn "Skipping symlink creation."
	exit 0
fi

echo ''
info "Continuing symlink setup process"

warn "Requesting sudo"
sudo -v

info "Processing symlinks in '$LIST_FILE'"

while read -r LINE; do
	SOURCE_CLEAN="${LINE%% > *}"
	SOURCE="${SOURCE_CLEAN/#\~/$HOME}"

	TARGET_CLEAN="${LINE#* > }"
	TARGET="${TARGET_CLEAN/#\~/$HOME}"

	info "  Processing symlink - '$TARGET_CLEAN' > '$SOURCE_CLEAN'"

	if [ ! -d $SOURCE ] && [ ! -L $SOURCE ]; then
		error "  Skipping as source '$SOURCE_CLEAN' doesn't exist"
	elif [ -d $TARGET ]; then
		error "  Skipping as target '$TARGET_CLEAN' already exists"
	else
		info "  Creating symlink - '$TARGET_CLEAN' > '$SOURCE_CLEAN'"

		TARGET_PARENT=$(dirname "$TARGET")
		sudo mkdir -p $TARGET_PARENT
		sudo chown -R $USER_NAME:$GROUP_NAME $TARGET_PARENT

	  sudo ln -s $SOURCE $TARGET
	  sudo chown -R $USER_NAME:$GROUP_NAME $TARGET
	fi
done < "$LIST_FILE"
