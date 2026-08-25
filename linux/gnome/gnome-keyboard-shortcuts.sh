#!/usr/bin/env bash
#
#
# Gnome - Set custom keyboard shortcuts
#
#

source "$HOME/Dotfiles/bin/utils.sh"
REPO="$(dir_repo)"
OS="$(os)"
OS_DESKTOP="$(os_desktop)"
BIN="$REPO/bin"
cd "$REPO"

if [[ "$OS" == "macOS" || "$OS" == "Windows" ]]; then
  error "This script requires Linux."
  exit 0
fi

if [[ "$OS_DESKTOP" != "gnome" ]]; then
  error "This script requires Gnome to be set as the Linux Desktop Environment."
  exit 0
fi

backup_config

gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver '["Open"]'
gsettings set org.gnome.settings-daemon.plugins.media-keys logout '[]'

gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings '["/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/", "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"]'

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Task Manager'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'flatpak run io.missioncenter.MissionCenter'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Control><Alt>Delete'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ enable-in-lockscreen false

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'Discord'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command 'flatpak run com.discordapp.Discord'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding '<Super>c'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ enable-in-lockscreen false

gsettings set org.gnome.shell.extensions.tiling-assistant overridden-settings '{"org.gnome.mutter.edge-tiling": <false>}'
gsettings set org.gnome.shell.extensions.tiling-assistant tile-maximize '["<Super>Up", "<Super>KP_5"]'
gsettings set org.gnome.shell.extensions.tiling-assistant restore-window '["<Super>Down"]'
gsettings set org.gnome.shell.extensions.tiling-assistant tile-left-half '["<Super>Left", "<Super>KP_4"]'
gsettings set org.gnome.shell.extensions.tiling-assistant tile-right-half '["<Super>Right", "<Super>KP_6"]'

success 'Gnome setup completed'
