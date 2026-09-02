#!/usr/bin/env bash
#
#
# Linux - Setup symlinks from a list file
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
	error "This script requires Linux."
	exit 1
fi

if [[ ! -f "$LIST_FILE" ]]; then
	error "List file not found at '$LIST_FILE'"
	info "Review the example file at '$EXAMPLE_FILE'"
	exit 1
fi

warn "Requesting sudo"
sudo -v

info "Processing symlinks in '$LIST_FILE'"

while read -r LINE; do
	# TODO: split out the content of the line, extract source and target
	# TODO: skip if the source doesn't exist
	# TODO: skip if the target exists
	SOURCE=${LINE%% > *}
	TARGET=${LINE#* > }

	info "  Checking '$SOURCE' to '$TARGET'"

	if [ ! -d $SOURCE ]; then
		error "  Skipping as source '$SOURCE' doesn't exist"
	elif [ -d $TARGET ]; then
		error "  Skipping as target '$TARGET' already exists"
	else
		warn "  Creating symlink at '$SOURCE' to '$TARGET'"
	  sudo ln -s $SOURCE $TARGET
	  chown -R $USER_NAME:$GROUP_NAME $TARGET
	fi
done < "$LIST_FILE"
