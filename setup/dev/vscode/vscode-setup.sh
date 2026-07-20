#!/usr/bin/env bash
#
#
# Setup VS Code - https://code.visualstudio.com/
#   - The package list can be updated with: code --list-extensions > "./vscode.extensions.txt"
#
#

DIR="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$REPO"
source "$REPO/bin/utils.sh"
OS="$(os)"
BIN="$REPO/bin"

if ! command -v code &> /dev/null; then
	if command -v flatpak &> /dev/null; then
		info 'Installing VS Code via Flatpak'
		flatpak install --reinstall -y --user com.visualstudio.code
	else
		error 'Please install VS Code manually - https://code.visualstudio.com/'
		exit 1
	fi
fi

# Default to a standard confing for a Linux system
CONFIG_DIR="$HOME/.config/Code/User"
INSTALL_CMD="code --install-extension"

if [[ "$OS" == "macOS" ]]; then
  CONFIG_DIR="$HOME/.config/Code/User"
elif [[ "$OS" == "Windows" ]]; then
  CONFIG_DIR="$APPDATA\Code\User"
elif [ -d "$HOME/.var/app/com.visualstudio.code" ]; then
  # Linux system with a Flatpak install
  CONFIG_DIR="$HOME/.var/app/com.visualstudio.code/config/Code/User"
  INSTALL_CMD="flatpak run com.visualstudio.code --install-extension"
fi

mkdir -p "$CONFIG_DIR"

info 'VS Code - Backing up current config'

mv "$CONFIG_DIR/settings.json" "$CONFIG_DIR/settings.json.bak"

info 'VS Code - Copying over custom config'

cp "$DIR/settings.json" "$CONFIG_DIR/settings.json"

# Install all packages from the package list file in this dir

cat "$DIR/vscode.extensions.txt" | while read extension
do
  info "VS Code - Installing extension '$extension'"
  $INSTALL_CMD $extension > /dev/null 2>&1
done

success 'VS Code setup completed'
