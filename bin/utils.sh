#!/usr/bin/env bash
#
#
# Bash script helper functions
#
#

# Custom styled echo message helpers
info() { echo -e "\033[1;36mi ${1}\033[0m"; }
success() { echo -e "\033[1;32m✔ ${1}\033[0m"; }
warn() { echo -e "\033[1;33m! ${1}\033[0m"; }
error() { echo -e "\033[1;31m✗ ${1}\033[0m"; }

# Returns the absolute directory path to the repo
# root based on the location of this file. Assumes
# this file is one directory deeper than the repo root.
dir_repo() {
	echo "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
}

# Returns the absolute path of the executed script
# that ran this function.
dir_this() {
	echo "$(cd "$(dirname "$0")" && pwd)"
}

# Backup current user config files
backup_config() {
	NOW=$(date "+%Y%m%d-%H%M%S")
	BACKUPS="$(dir_repo)/.config/backups/$NOW"

	mkdir -p "$BACKUPS"

	crontab -l > "$BACKUPS/crontab.bak"

	cp "$HOME/".bash* "$BACKUPS"
	cp "$HOME/".git* "$BACKUPS"
	cp -r "$HOME/".vim* "$BACKUPS"
	cp -r "$HOME/".ssh "$BACKUPS"

	[ -e "$HOME/.env.local" ] && cp "$HOME/.env.local" "$BACKUPS"
	[ -e "$HOME/justfile" ] && cp "$HOME/justfile" "$BACKUPS"

	[ -f "$HOME/.face" ] && cp "$HOME/.face" "$BACKUPS"
	[ -f "$HOME/.face.icon" ] && cp "$HOME/.face.icon" "$BACKUPS"
	[ -f "$HOME/profile.png" ] && cp "$HOME/profile.png" "$BACKUPS"
	[ -f "/var/lib/AccountsService/icons/$USER" ] && cp "/var/lib/AccountsService/icons/$USER" "$BACKUPS"

	mkdir -p "$BACKUPS/.config"

	cp -r "$HOME/.config/user-dirs.dirs" "$BACKUPS/.config"
	cp -r "$HOME/.config/user-dirs.locale" "$BACKUPS/.config"

	success "New config backup saved in '$BACKUPS'"
}

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

# Checks if the OS is Debian based, return "true" or "false" as a string.
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

# Get the name of the Linux Desktop Environment.
os_desktop() {
	OS="$(os)"

	if [[ "$OS" == "macOS" || "$OS" == "Windows" ]]; then
		echo ""
	else
  	echo "$(echo ${XDG_CURRENT_DESKTOP#ubuntu:} | tr '[:upper:]' '[:lower:]' | tr ' ' '-')";
	fi
}
