#!/usr/bin/env bash
#
#
# Ubuntu: Add packages and update config to improve gaming performance
#
#

DIR="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO"
source "$REPO/bin/utils.sh"
OS="$(os)"
OS_DESKTOP="$(os_desktop)"

if [[ "$OS" == "macOS" ]] || [[ "$OS" == "Windows" ]]; then
  echo "This script requires Linux."
  exit 0
fi

warn 'Requesting sudo access'
sudo -v

if [[ "$OS" == "EndeavourOS" ]]; then
  info 'EndeavourOS - Install supporting packages'

  sudo pacman -Syu --noconfirm \
  	steam \
   	dkms \
    linux-headers \
    cabextract > /dev/null 2>&1

  yay -Syu --noconfirm game-devices-udev > /dev/null 2>&1

elif [[ "$OS" == "Fedora" ]]; then

  info 'Fedora - Install supporting packages'

  sudo dnf install -y \
  	dkms \
   	kernel-devel \
    kernel-headers \
    cabextract \
    steam-devices \
    screenfetch > /dev/null 2>&1

  if [ -n "$(lspci | grep -i nvidia)" ]; then
    info 'Fedora - Setup for Nvidia graphics card'

    sudo dnf install -y "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
    sudo dnf install -y "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

    sudo dnf install -y \
    	nvidia-smi \
    	akmod-nvidia \
    	xorg-x11-drv-nvidia-cuda \
    	kernel-devel-matched \
    	kernel-headers > /dev/null 2>&1

    sudo akmods --force
    sudo dracut --force
  fi

  info 'Fedora - Installing Steam'
  # From https://docs.fedoraproject.org/en-US/gaming/proton/
  sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1
  sudo dnf install -y steam

elif [ "$(os_debian_based)" ]; then
  info "$OS - Install supporting packages"

  sudo apt update -qq > /dev/null 2>&1

  sudo apt -qq --assume-yes install \
    cmake \
    systemd \
    libsystemd-dev \
    systemd-dev \
    pkg-config \
    meson \
    libsystemd-dev \
    pkg-config \
    ninja-build \
    git \
    dbus-user-session \
    libdbus-1-dev \
    libinih-dev \
    build-essential \
    dkms \
    curl \
    cabextract \
    cpufrequtils > /dev/null 2>&1

  info "$OS - Installing Steam"

  sudo dpkg --add-architecture i386 > /dev/null 2>&1
  sudo apt update -qq > /dev/null 2>&1
  sudo apt -qq --assume-yes install libnvidia-gl-595:i386 > /dev/null 2>&1

  STEAM_DEB="$HOME/Downloads/temp-steam_latest.deb"
  rm -rf "$STEAM_DEB"
  curl --output "$STEAM_DEB" "https://repo.steampowered.com/steam/archive/stable/steam_latest-stable.deb" > /dev/null 2>&1
  sudo apt -qq --assume-yes install "$STEAM_DEB"
  rm -rf "$STEAM_DEB"

  sudo apt -qq --assume-yes install \
  	steam-libs-i386 steam-libs-amd64:amd64 \
   	libc6:amd64 libc6:i386 libegl1:amd64 libegl1:i386 \
    libgbm1:amd64 libgbm1:i386 libgl1-mesa-dri:amd64 \
    libgl1-mesa-dri:i386 libgl1:amd64 libgl1:i386 > /dev/null 2>&1
fi

if [[ "$OS" == "Ubuntu" ]]; then
  info 'Ubuntu - Disable mouse pointer acceleration'

  xset m 0 0
fi

if [[ "$OS_DESKTOP" == "gnome" ]]; then
	info 'Gnome - Disable mouse pointer acceleration'
  gsettings set org.gnome.desktop.peripherals.mouse accel-profile 'flat'
  gsettings set org.gnome.desktop.peripherals.touchpad accel-profile 'flat'

  info 'Gnome - Update mouse pointer speed'
  gsettings set org.gnome.desktop.peripherals.mouse speed '0.4897119341563787'

  info 'Gnome - Disabling natural scrolling'
  gsettings set org.gnome.desktop.peripherals.mouse natural-scroll false

  info 'Gnome - Disable Gnome UI animations'
  gsettings set org.gnome.desktop.interface enable-animations false

  info 'Gnome - Set non-responding app warning timeout to 1 min'
  gsettings set org.gnome.mutter check-alive-timeout 60000
fi

info 'Setup Gamemode'

rm -rf "$HOME/.gamemode"
git clone --quiet "https://github.com/FeralInteractive/gamemode.git" "$HOME/.gamemode"
cd "$HOME/.gamemode"
git checkout --quiet 1.8.2

yes | bash "./bootstrap.sh" > /dev/null 2>&1

sudo usermod -aG gamemode $(whoami)

touch "$HOME/.config/gamemode.ini"
cp "$HOME/.config/gamemode.ini" "$HOME/.config/gamemode.ini.old"
cp "$DIR/gamemode.ini" "$HOME/.config/gamemode.ini"

if ! command -v flatpak > /dev/null 2>&1 ; then
  warn "Skipping Flatpak installs, please setup Flatpak first - bash $REPO/setup/linux/packages/flatpak.sh"
else
  info 'Installing Discord via Flatpak'
  flatpak install --assumeyes --or-update com.discordapp.Discord

  info 'Installing Lutris via Flatpak'
  flatpak install --assumeyes --or-update net.lutris.Lutris

  info 'Installing ProtonPlus via Flatpak'
  flatpak install --assumeyes --or-update com.vysp3r.ProtonPlus

  info 'Installing Solaar via Flatpak'
  flatpak install --assumeyes --or-update io.github.pwr_solaar.solaar
fi

info 'Installing Xbox Controllers firmware'

rm -rf "$HOME/.xone"
git clone --quiet "https://github.com/medusalix/xone" "$HOME/.xone"
cd "$HOME/.xone"
sudo "./install.sh" --release
sudo "xone-get-firmware.sh"

success 'Finished, a system reboot is recommended'
