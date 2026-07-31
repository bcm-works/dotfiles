#!/usr/bin/env bash
#
#
# Linux Mint 22 setup
#
#

REPO="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$REPO"
source "$REPO/bin/utils.sh"
OS="$(os)"

if [[ "$OS" != "Mint" ]]; then
  error "This script requires Linux Mint."
  exit 0
fi

warn 'Mint: Requesting sudo'
sudo -v

info 'Mint: Update package lists'

sudo apt update -qq > /dev/null 2>&1

info 'Mint: Install base system packages'

sudo apt -qq --assume-yes install \
	curl vim ddcutil \
	zip p7zip p7zip-full \
	clamav-freshclam clamav-daemon \
	gsettings-desktop-schemas > /dev/null 2>&1

info 'Mint: Setup Flatpak'

bash "$REPO/setup/linux/packages/linux-flatpak.sh"

info 'Mint: Installing Nemo Preview document preview app'

sudo apt -qq --assume-yes install nemo-preview > /dev/null 2>&1

info 'Mint: Disabling printer notifications'

sudo systemctl stop cups-browsed
sudo systemctl disable cups-browsed

info 'Mint: Applying system config values'

gsettings set org.cinnamon.desktop.background color-shading-type 'solid'
gsettings set org.cinnamon.desktop.background picture-opacity 100
gsettings set org.cinnamon.desktop.background picture-options 'stretched'
gsettings set org.cinnamon.desktop.background primary-color '#000000'
gsettings set org.cinnamon.desktop.background secondary-color '#000000'

gsettings set org.cinnamon.desktop.interface clock-show-date true
gsettings set org.cinnamon.desktop.interface clock-show-seconds false
gsettings set org.cinnamon.desktop.interface first-day-of-week 1
gsettings set org.cinnamon.desktop.interface clock-use-24h false

gsettings set org.cinnamon.theme name 'Mint-Y-Dark-Teal'
gsettings set org.cinnamon.desktop.interface font-name 'Ubuntu 11'
gsettings set org.cinnamon.desktop.interface gtk-theme 'Mint-Y-Dark-Teal'
gsettings set org.cinnamon.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.cinnamon.desktop.interface buttons-have-icons true
gsettings set org.cinnamon.desktop.interface menus-have-icons true
gsettings set org.cinnamon.desktop.interface cursor-size 24
gsettings set org.cinnamon.desktop.interface cursor-theme 'DMZ-Black'

gsettings set org.cinnamon.desktop.interface gtk-enable-primary-paste false

gsettings set org.cinnamon.desktop.media-handling automount true
gsettings set org.cinnamon.desktop.media-handling automount-open false
gsettings set org.cinnamon.desktop.media-handling autorun-never true

gsettings set org.cinnamon.desktop.peripherals.mouse accel-profile 'flat'
gsettings set org.cinnamon.desktop.peripherals.mouse speed 0.4212765957446809

gsettings set org.cinnamon.desktop.notifications bottom-notifications true
gsettings set org.cinnamon.desktop.notifications notification-duration 4

gsettings set org.cinnamon.desktop.privacy old-files-age 7
gsettings set org.cinnamon.desktop.privacy recent-files-max-age 1
gsettings set org.cinnamon.desktop.privacy remember-recent-files false
gsettings set org.cinnamon.desktop.privacy remove-old-temp-files true
gsettings set org.cinnamon.desktop.privacy remove-old-trash-files true

gsettings set org.cinnamon.desktop.screensaver allow-keyboard-shortcuts false
gsettings set org.cinnamon.desktop.screensaver allow-media-control false
gsettings set org.cinnamon.desktop.screensaver floating-widgets false
gsettings set org.cinnamon.desktop.screensaver show-album-art false
gsettings set org.cinnamon.desktop.screensaver show-info-panel false

gsettings set org.cinnamon.desktop.wm.preferences action-middle-click-titlebar 'none'
gsettings set org.cinnamon.desktop.wm.preferences titlebar-font 'Ubuntu Medium 11'

gsettings set org.cinnamon.desktop.default-applications.terminal exec 'gnome-terminal'
gsettings set org.cinnamon.desktop.default-applications.calculator exec 'gnome-calculator'

gsettings set org.cinnamon.desktop.keybindings looking-glass-keybinding []
gsettings set org.cinnamon.desktop.keybindings.media-keys screensaver '["<Control><Alt>l", "XF86ScreenSaver", "<Super>l"]'
gsettings set org.cinnamon.desktop.keybindings.media-keys area-screenshot '["<Shift><Super>dollar"]'
gsettings set org.cinnamon.desktop.keybindings.media-keys calculator []
gsettings set org.cinnamon.desktop.keybindings.media-keys email []
gsettings set org.cinnamon.desktop.keybindings.media-keys home []
gsettings set org.cinnamon.desktop.keybindings.media-keys www []
