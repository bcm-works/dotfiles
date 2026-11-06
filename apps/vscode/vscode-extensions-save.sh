#!/usr/bin/env bash
#
#
# Saves VS Code extensions to 'extensions.json'
#
#

source "$HOME/Dotfiles/utils.sh"
REPO="$(dir_repo)"
DIR="$(dir_this)"
cd "$DIR"

if command -v code &> /dev/null; then
  success 'VS Code is already installed'
else
	error 'Please install VS Code first.'
	exit 1
fi

EXTS=$(code --list-extensions | sed 's/.*/"&",/')
CONTENT="{ \""recommendations\"": [ $EXTS ] }"
FILE="$DIR/extensions.json"

rm -rf $FILE

echo $CONTENT > $FILE

success 'VS Code extensions saved'
