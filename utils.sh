#!/usr/bin/env bash
#
#
# Dotfiles helper functions
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
	echo "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
}

# Returns the absolute path of the executed script
# that ran this function.
dir_this() {
	echo "$(cd "$(dirname "$0")" && pwd)"
}

# Append a formatted log line to a file, along with
# suitable defaults if no params are provided, and
# attempt to create the log file's parent dir too.
#
# Usage: log_file ./something.log "example log message"
log_file() {
	local LOG_FILE="${1:-$(dir_this)/$0.log}"
	local LOG_DIR="$(cd "$(dirname "$LOG_FILE")" && pwd)"
	local LOG_FMT="+%Y-%m-%d %H:%M:%S"
	local LOG_MESSAGE="${2:- }"

	mkdir -p "$LOG_DIR"
	touch "$LOG_FILE"

	echo $(date "$LOG_FMT") "$LOG_MESSAGE" >> "$LOG_FILE"
}

# Backup current user config files
backup_config() {
	NOW=$(date "+%Y%m%d-%H%M%S")
	DEST="$(dir_repo)/config/backups/$NOW"

	mkdir -p "$DEST"
	mkdir -p "$DEST/config"
	mkdir -p "$DEST/profile-image"

	cp "$HOME/".bash* "$DEST"

	[ -f "$HOME/.gitconfig" ] && cp "$HOME/.gitconfig" "$DEST"

	[ -f "$HOME/.vimrc" ] && cp "$HOME/.vimrc" "$DEST"
	[ -d "$HOME/.vim" ] && cp -r "$HOME/.vim" "$DEST"

	[ -d "$HOME/.config/hypr" ] && cp -r "$HOME/.config/hypr" "$DEST/config"
	[ -d "$HOME/.config/kitty" ] && cp -r "$HOME/.config/kitty" "$DEST/config"

	[ -d "$HOME/.ssh/config" ] && cp "$HOME/.ssh/config" "$DEST/.ssh-config.txt"
	[ -e "$HOME/.env.local" ] && cp "$HOME/.env.local" "$DEST"
	[ -e "$HOME/justfile" ] && cp "$HOME/justfile" "$DEST"

	[ -f "$HOME/.face" ] && cp "$HOME/.face" "$DEST/profile-image"
	[ -f "$HOME/.face.icon" ] && cp "$HOME/.face.icon" "$DEST/profile-image"
	[ -f "$HOME/profile.png" ] && cp "$HOME/profile.png" "$DEST/profile-image"
	[ -f "/var/lib/AccountsService/icons/$USER" ] && cp "/var/lib/AccountsService/icons/$USER" "$DEST/profile-image"

	[ -f "$HOME/.config/user-dirs.dirs" ] && cp -r "$HOME/.config/user-dirs.dirs" "$DEST/config"
	[ -f "$HOME/.config/user-dirs.locale" ] && cp -r "$HOME/.config/user-dirs.locale" "$DEST/config"

	if command -v dconf > /dev/null 2>&1 ; then
  	dconf dump / > "$DEST/dconf.conf"
	fi

	if command -v crontab > /dev/null 2>&1 ; then
  	crontab -l > "$DEST/crontab-user.txt"
	fi

	success "Current config saved to '$DEST'"
}

# Returns the name of the Operating System
os() {
  OS="$(uname -s)";
  if [[ "$OS" == 'Freedesktop SDK' ]]; then
    echo 'Linux';
  elif [[ "$OS" == 'Linux' ]]; then
    DISTRO_NAME="$(source /etc/os-release && echo $NAME)";
    if [[ "$DISTRO_NAME" == 'Fedora Linux' ]]; then
  		if command -v rpm-ostree &> /dev/null; then
   			echo 'Fedora Atomic';
  		else
    		echo 'Fedora';
     	fi
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

  if [[ "$OS" == "macOS" || "$OS" == "Windows" || "$OS" == "Fedora" || "$OS" == "Fedora Atomic" ]]; then
    echo "false";
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
		echo "$(echo ${XDG_CURRENT_DESKTOP#ubuntu:})";
	fi
}

# Returns the name of the Linux Desktop Environment, lowercase and with dashes instead of spaces
os_desktop_clean() {
  echo "$(os_desktop | tr '[:upper:]' '[:lower:]' | tr ' ' '-')";
}
