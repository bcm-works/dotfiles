#!/usr/bin/env bash

source "$HOME/Dotfiles/utils.sh"

DIR="$HOME/Dotfiles/tools/organise-media"

if [ ! -f "$DIR/.organise-media.env" ]; then
	cp "$DIR/.organise-media.sample.env" "$DIR/.organise-media.env"

	error "Please edit the new env file first - '$DIR/.organise-media.env'"
	exit 1
fi

VENV_DIR="$DIR/.venv"
mkdir -p "$VENV_DIR"
python -m venv "$VENV_DIR"

"$VENV_DIR/bin/python" -m pip install -r "$DIR/requirements.txt"

success "Dependencies installed to '$VENV_DIR'"
