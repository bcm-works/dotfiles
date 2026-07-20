#!/usr/bin/env bash
#
#
# Bash script helper functions
#
#

info() { echo -e "\033[1;36mi\u2009\033[0m$1"; }
success() { echo -e "\033[1;32m✔\u2009\033[0m$1"; }
warn() { echo -e "\033[1;33m!\u2009\033[0m$1"; }
error() { echo -e "\033[1;31m✗\u2009\033[0m$1"; }

# Returns the name of the Operating System
os() {
  OS="$(uname -s)";
  if [[ "$OS" == 'Freedesktop SDK' ]]; then
    echo 'Linux';
  elif [[ "$OS" == 'Linux' ]]; then
    DISTRO_NAME="$(source /etc/os-release && echo $NAME)";
    if [[ "$DISTRO_NAME" == 'Fedora Linux' ]]; then
      echo 'Fedora';
    elif [[ "$DISTRO_NAME" == 'Debian GNU/Linux' ]]; then
      echo 'Debian';
    elif [[ "$DISTRO_NAME" == 'Linux Mint' ]]; then
      echo 'Mint';
    elif [[ "$DISTRO_NAME" == 'Pop!_OS' ]]; then
      echo 'PopOS';
    else
      echo "${DISTRO_NAME}";
    fi
  elif [[ "$OS" == 'Darwin' ]]; then
    echo 'macOS';
  elif [[ "$OS" == 'CYGWIN' || "$OS" == 'MINGW' || "$OS" == 'MSYS_NT' ]]; then
    echo 'Windows';
  else
    echo "${OS}";
  fi
}

# Returns the name of the Operating System, lowercase and with dashes instead of spaces
os_clean() {
  echo "$(os | tr '[:upper:]' '[:lower:]' | tr ' ' '-')";
}

# Checks if the OS is Debian based, returns "true" or "false" as strings.
os_debian_based() {
  OS="$(os)"

  if [[ "$OS" == "macOS" || "$OS" == "Windows" ]]; then
    echo "false"
  fi

  if [ ! -f "/etc/os-release" ]; then
    echo "false"
  fi

  source "/etc/os-release"

  if [[ "$ID" == "debian" || "$ID_LIKE" == *"debian"* ]]; then
    echo "true"
  else
  	echo "false"
  fi
}

# Get the name of the Linux Desktop Environment
os_desktop() {
	echo "$(echo $XDG_CURRENT_DESKTOP | tr '[:upper:]' '[:lower:]' | tr ' ' '-')";
}
