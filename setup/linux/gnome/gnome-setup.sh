#!/usr/bin/env bash
#
#
# Setup Gnome
#   - Customise user level Gnome settings
#
#

THIS_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$REPO"
source "$REPO/bin/utils.sh"
OS="$(os)"
OS_DESKTOP="$(os_desktop)"
BIN="$REPO/bin"

if [[ "$OS" == "macOS" || "$OS" == "Windows" ]]; then
  echo "This script requires Linux."
  exit 0
fi

if [[ "$OS_DESKTOP" != "gnome" ]]; then
  echo "This script requires Gnome to be set as the Linux Desktop Environment."
  exit 0
fi

echo 'Requesting sudo access'

sudo -v

echo 'Installing supporting packages for Gnome Shell Extensions'

if [[ "$OS" == "Ubuntu" ]]; then
  sudo apt install -y \
    gnome-browser-connector \
    python3 \
    pipx > /dev/null 2>&1
elif [[ "$OS" == "EndeavourOS" ]]; then
  sudo pacman -Syu --noconfirm \
    gnome-browser-connector \
    python \
    python-pipx > /dev/null 2>&1
elif [[ "$OS" == "Fedora" ]]; then
  sudo dnf install -y \
    gnome-browser-connector \
    python3 \
    pipx > /dev/null 2>&1
fi

pipx ensurepath > /dev/null 2>&1
pipx install --force gnome-extensions-cli --system-site-packages > /dev/null 2>&1

if [[ -f "$REPO/config/packages/gnome-extension.list.txt" ]]; then
	info "Installing Gnome Shell Extensions from '$REPO/config/packages/gnome-extension.list.txt'"
	xargs -I {} gnome-extensions-cli install {} < "$REPO/config/packages/gnome-extension.list.txt"
else
	warn "Skipping Gnome Shell Extensions installs, file not found at '$REPO/config/packages/gnome-extension.list.txt'"
fi

# Helper function to check if a Dconf Settings Schema exists
has_schema () {
  DCONF_SCHEMA_FOUND=$(gsettings list-schemas | grep -qw "$1");
  if [[ -n "$DCONF_SCHEMA_FOUND" ]]; then
    # Schema found, return 0 for "no error"
    return 0
  else
    # Schema not found, return 1 for "error"
    return 1
  fi
}

echo 'Applying customised Gnome Settings'

# Theme

if [[ "$OS" == "EndeavourOS" ]]; then
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
  gsettings set org.gnome.desktop.interface accent-color 'teal'
  gsettings set org.gnome.desktop.interface icon-theme 'Adwaita-dark'
  gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
  gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'
  gsettings set org.gnome.desktop.interface cursor-size 24
elif [[ "$OS" == "Ubuntu" ]]; then
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
  gsettings set org.gnome.desktop.interface accent-color 'teal'
  gsettings set org.gnome.desktop.interface icon-theme 'Yaru-prussiangreen-dark'
  gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-prussiangreen-dark'
  gsettings set org.gnome.desktop.interface cursor-theme 'Yaru'
  gsettings set org.gnome.desktop.interface cursor-size 24
fi

# Interface customisations

gsettings set org.gnome.desktop.interface gtk-enable-primary-paste false
gsettings set org.gnome.desktop.interface toolbar-icons-size 'large'
gsettings set org.gnome.desktop.interface toolbar-style 'text'
gsettings set org.gnome.desktop.wm.preferences audible-bell false
gsettings set org.gnome.desktop.wm.preferences visual-bell false
gsettings set org.gnome.desktop.wm.preferences visual-bell-type 'frame-flash'

# Window management

gsettings set org.gnome.shell.window-switcher app-icon-mode 'both'
gsettings set org.gnome.shell.window-switcher current-workspace-only true
gsettings set org.gnome.mutter attach-modal-dialogs true
gsettings set org.gnome.mutter auto-maximize false
gsettings set org.gnome.mutter center-new-windows false
gsettings set org.gnome.mutter dynamic-workspaces true
gsettings set org.gnome.mutter edge-tiling true
gsettings set org.gnome.desktop.interface enable-hot-corners false
gsettings set org.gnome.desktop.wm.preferences theme 'Adwaita'
gsettings set org.gnome.desktop.wm.preferences button-layout 'icon:minimize,maximize,close'
gsettings set org.gnome.desktop.wm.preferences num-workspaces 3
gsettings set org.gnome.desktop.wm.preferences action-double-click-titlebar 'toggle-maximize'
gsettings set org.gnome.desktop.wm.preferences action-middle-click-titlebar 'none'
gsettings set org.gnome.desktop.wm.preferences resize-with-right-button false
gsettings set org.gnome.desktop.wm.preferences focus-mode 'click'
gsettings set org.gnome.desktop.wm.preferences focus-new-windows 'smart'
gsettings set org.gnome.desktop.wm.preferences auto-raise true
gsettings set org.gnome.desktop.wm.preferences auto-raise-delay 0

# Extensions

gsettings set org.gnome.shell allow-extension-installation true
gsettings set org.gnome.shell disable-user-extensions false
gsettings set org.gnome.shell always-show-log-out true
gsettings set org.gnome.shell development-tools true

# App: Nautilus

gsettings set org.gnome.nautilus.window-state maximized false
gsettings set org.gnome.nautilus.icon-view captions '["type", "size", "date_modified"]'
gsettings set org.gnome.nautilus.icon-view default-zoom-level 'medium'
gsettings set org.gnome.nautilus.preferences default-folder-viewer 'icon-view'
gsettings set org.gnome.nautilus.preferences default-sort-order 'name'
gsettings set org.gnome.nautilus.preferences show-create-link true
gsettings set org.gnome.nautilus.preferences show-directory-item-counts 'local-only'
gsettings set org.gnome.nautilus.preferences date-time-format 'simple'
gsettings set org.gnome.nautilus.compression default-compression-format 'zip'
gsettings set org.gnome.nautilus.preferences search-filter-time-type 'last_modified'
gsettings set org.gnome.nautilus.preferences open-folder-on-dnd-hover false
gsettings set org.gnome.nautilus.preferences click-policy 'double'
gsettings set org.gnome.nautilus.preferences show-hidden-files true
gsettings set org.gnome.nautilus.compression default-compression-format 'encrypted_zip'

# File lists

gsettings set org.gtk.gtk4.Settings.FileChooser sort-column 'name'
gsettings set org.gtk.gtk4.Settings.FileChooser sort-order 'ascending'
gsettings set org.gtk.gtk4.Settings.FileChooser sort-directories-first true
gsettings set org.gtk.gtk4.Settings.FileChooser startup-mode 'cwd'
gsettings set org.gtk.gtk4.Settings.FileChooser show-hidden true
gsettings set org.gtk.gtk4.Settings.FileChooser type-format 'category'
gsettings set org.gtk.gtk4.Settings.FileChooser view-type 'grid'
gsettings set org.gtk.gtk4.Settings.FileChooser clock-format '12h'
gsettings set org.gtk.gtk4.Settings.FileChooser show-size-column true
gsettings set org.gtk.gtk4.Settings.FileChooser show-type-column true

# Keyboard shortcuts

gsettings set org.gnome.shell.keybindings toggle-overview '["<Control><Super>Up"]'
gsettings set org.gnome.shell.keybindings screenshot '[]'
gsettings set org.gnome.shell.keybindings screenshot-window '[]'
gsettings set org.gnome.shell.keybindings show-screen-recording-ui '[]'
gsettings set org.gnome.shell.keybindings show-screenshot-ui '["Print"]'
gsettings set org.gnome.shell.keybindings toggle-quick-settings '["<Super>s"]'

# Date and Time

gsettings set org.gnome.desktop.datetime automatic-timezone true
gsettings set org.gnome.desktop.interface clock-format '12h'
gsettings set org.gnome.desktop.interface clock-show-weekday true
gsettings set org.gnome.desktop.interface clock-show-date true

# Hardware

gsettings set org.gnome.desktop.media-handling automount true
gsettings set org.gnome.desktop.media-handling automount-open false
gsettings set org.gnome.desktop.media-handling autorun-never true
gsettings set org.gnome.desktop.peripherals.touchpad accel-profile 'flat'
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false
gsettings set org.gnome.desktop.peripherals.mouse natural-scroll false
gsettings set org.gnome.desktop.peripherals.mouse accel-profile 'flat'
gsettings set org.gnome.desktop.peripherals.mouse speed 0.2243346007604563

# Privacy

gsettings set org.gnome.desktop.notifications show-in-lock-screen false
gsettings set org.gnome.desktop.privacy usb-protection true
gsettings set org.gnome.desktop.privacy usb-protection-level 'lockscreen'
gsettings set org.gnome.desktop.privacy show-full-name-in-top-bar false
gsettings set org.gnome.desktop.privacy send-software-usage-stats false
gsettings set org.gnome.desktop.privacy report-technical-problems false
gsettings set org.gnome.desktop.privacy remove-old-temp-files true
gsettings set org.gnome.desktop.privacy remove-old-trash-files true
gsettings set org.gnome.desktop.privacy old-files-age 7
gsettings set org.gnome.desktop.privacy remember-recent-files false
gsettings set org.gnome.desktop.privacy recent-files-max-age '-1'
gsettings set org.gnome.system.location enabled false
gsettings set org.gnome.system.location max-accuracy-level 'neighborhood'
gsettings set org.gnome.clocks geolocation false
gsettings set org.gnome.desktop.screensaver lock-enabled true
gsettings set org.gnome.desktop.screensaver lock-delay 0
gsettings set org.gnome.desktop.screensaver show-full-name-in-top-bar false
gsettings set org.gnome.desktop.screensaver user-switch-enabled true
gsettings set org.gnome.shell always-show-log-out true

if [[ "$OS" == "Ubuntu" ]]; then
  gsettings set org.gnome.desktop.screensaver ubuntu-lock-on-suspend true
fi

# Power and performance

if powerprofilesctl > /dev/null 2>&1; then
  powerprofilesctl set performance
fi

gsettings set org.gnome.shell last-selected-power-profile 'performance'
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.mutter experimental-features '["scale-monitor-framebuffer", "variable-refresh-rate", "xwayland-native-scaling"]'

# App: Console

if has_schema "org.gnome.Console"; then
  gsettings set org.gnome.Console audible-bell false
  gsettings set org.gnome.Console visual-bell false
  gsettings set org.gnome.Console custom-font 'Monospace 13'
  gsettings set org.gnome.Console use-system-font false
  gsettings set org.gnome.Console theme 'night'
  gsettings set org.gnome.Console shell '["/bin/bash"]'
  gsettings set org.gnome.Console scrollback-lines '10000'
  gsettings set org.gnome.Console transparency false
fi

# App: TextEditor

gsettings set org.gnome.TextEditor custom-font 'Monospace 13'
gsettings set org.gnome.TextEditor style-scheme 'classic-dark'
gsettings set org.gnome.TextEditor style-variant 'dark'
gsettings set org.gnome.TextEditor auto-indent true
gsettings set org.gnome.TextEditor highlight-current-line true
gsettings set org.gnome.TextEditor highlight-matching-brackets true
gsettings set org.gnome.TextEditor indent-style 'tab'
gsettings set org.gnome.TextEditor indent-width 2
gsettings set org.gnome.TextEditor tab-width 2
gsettings set org.gnome.TextEditor spellcheck false
gsettings set org.gnome.TextEditor use-system-font false
gsettings set org.gnome.TextEditor wrap-text true

# App: Tweaks

if has_schema "org.gnome.tweaks"; then
  gsettings set org.gnome.tweaks show-extensions-notice false
fi

# App: Settings

gsettings set org.gnome.Settings show-development-warning false
gsettings set org.gnome.Settings last-panel 'system'

# Ubuntu Tiling Assistant

if has_schema "org.gnome.shell.extensions.tiling-assistant"; then
  gsettings set org.gnome.mutter edge-tiling false
  gsettings set org.gnome.shell.extensions.tiling-assistant enable-raise-tile-group false
  gsettings set org.gnome.shell.extensions.tiling-assistant enable-tiling-popup false
  gsettings set org.gnome.shell.extensions.tiling-assistant tiling-popup-all-workspace false
  gsettings set org.gnome.shell.extensions.tiling-assistant enable-tile-animations true
  gsettings set org.gnome.shell.extensions.tiling-assistant enable-untile-animations true
  gsettings set org.gnome.shell.extensions.tiling-assistant toggle-tiling-popup '[]'
  gsettings set org.gnome.shell.extensions.tiling-assistant overridden-settings '{"org.gnome.mutter.edge-tiling": <false>}'
  gsettings set org.gnome.shell.extensions.tiling-assistant restore-window '["<Super>Down"]'
  gsettings set org.gnome.shell.extensions.tiling-assistant tile-left-half '["<Super>Left", "<Super>KP_4"]'
  gsettings set org.gnome.shell.extensions.tiling-assistant tile-right-half '["<Super>Right", "<Super>KP_6"]'
fi
