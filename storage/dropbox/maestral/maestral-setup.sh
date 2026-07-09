#!/usr/bin/env bash
#
#
# Dropbox - Setup Maestral client app for Dropbox
#   - More info: https://maestral.app/
#   - Config file reference: https://maestral.app/docs/configfile
#
#

DIR="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$REPO"
source "$REPO/bin/.helper.sh"
OS="$(os)"
BIN="$REPO/bin"

if [[ "$OS" == "macOS" ]] || [[ "$OS" == "Windows" ]]; then
  echo "This script requires Linux."
  exit 0
fi

echo '==> Requesting sudo'

sudo -v

echo '==> Installing dependencies'

if [[ "$OS" == "Ubuntu" ]]; then
  sudo apt -qq --assume-yes install python3 python-is-python3 python3-gpg python3-pyqt5 pipx
elif [[ "$OS" == "Fedora" ]]; then
  sudo dnf install -y python3 python3-qt5 pipx
fi

pipx install --force pyqt5

echo '==> Installing Maestral'

pipx install --force maestral[gui]
pipx install --force maestral-qt

echo '==> Configuring Maestral'

maestral start
maestral bandwidth-limit up 0
maestral bandwidth-limit down 0
maestral notify level SYNCISSUE
maestral autostart --yes
maestral auth link

echo '==> Copying over Maestral ignore list'

cp "$DIR/maestral.ignore.txt" "$(maestral config get path)/.mignore"

echo '==> Adding symlink at /usr/bin/maestral'

sudo rm -rf '/usr/bin/maestral'
sudo ln -s "$(which maestral)" '/usr/bin/maestral'
sudo chmod a+x '/usr/bin/maestral'

echo '==> Copying over app icon and applications menu item'

mkdir -p "$HOME/.local/share/icons/hicolor/512x512/apps"
cp "$DIR/maestral.png" "$HOME/.local/share/icons/hicolor/512x512/apps/Maestral.png"

mkdir -p "$HOME/.local/share/applications"
rm -rf "$HOME/.local/share/applications/Maestral.desktop"
cp "$DIR/maestral.desktop" "$HOME/.local/share/applications/Maestral.desktop"
echo "" >> "$HOME/.local/share/applications/Maestral.desktop"
echo "Icon=$HOME/.local/share/icons/hicolor/512x512/apps/Maestral.png" >> "$HOME/.local/share/applications/Maestral.desktop"
chmod a+x "$HOME/.local/share/applications/Maestral.desktop"

mkdir -p "$HOME/.config/autostart"
rm -rf "$HOME/.config/autostart/Maestral.desktop"
cp "$DIR/maestral.desktop" "$HOME/.config/autostart/Maestral.desktop"
echo "" >> "$HOME/.config/autostart/Maestral.desktop"
echo "Icon=$HOME/.local/share/icons/hicolor/512x512/apps/Maestral.png" >> "$HOME/.config/autostart/Maestral.desktop"
chmod a+x "$HOME/.config/autostart/Maestral.desktop"

echo '==> Updating launcher application list'

update-desktop-database ~/.local/share/applications
xdg-desktop-menu forceupdate

echo '==> Done, you can now open Maestral via the applications menu'
