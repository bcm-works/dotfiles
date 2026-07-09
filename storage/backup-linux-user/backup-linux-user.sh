#!/usr/bin/env bash
#
#
# Backup some of the current Linux User's config files
#  - Makes a timestamped and password protected ZIP file of some parts of your User directory
#  - Include and exclude rules (starting with "-x") are set in the "zip" command below
#  - Saves symlinks as links, not as directories
#  - Saves output messages to the file set in LOG_FILE
#  - If your system's scheduler is cron, setup by running 'crontab -e', then adding a line:
#    0 19 * * * bash /home/username/dotfiles/storage/backup-linux-user/backup-linux-user.sh
#  - If your system's scheduler is systemd, refer to 'backup-linux-user.service'
#
#

DIR="$(dirname "$(readlink -f "$0")")"
REPO="$(cd "$(dirname "$0")/../.." && pwd)"
source "$REPO/bin/.helper.sh"
OS="$(os)"
OS_CLEAN="$(os_clean)"

cd "$DIR"

LOG_FILE="$DIR/backup-linux-user.log"
LOG_FMT="+%Y-%m-%d %H:%M:%S"
touch "$LOG_FILE"

cp --update=none "$DIR/.backup-linux-user.sample.env" "$DIR/.backup-linux-user.env"
source "$DIR/.backup-linux-user.env"

mkdir -p "$BACKUP_DIR"

# Default to backing up the current user's home directory

SOURCE_DIR="$HOME"
BACKUP_USER_NAME="$(id -un)"

# Exit if the source directory doesn't exist

if [ ! -d "$SOURCE_DIR" ]; then
  echo $(date "$LOG_FMT") "Error - Source directory ($SOURCE_DIR) not found, please check the path in the script" >> "$LOG_FILE"
  exit 1
fi

# Construct backup paths

BACKUP_FILE="${OS_CLEAN}-user-${BACKUP_USER_NAME}_$(date +%Y%m%d-%H%M%S).zip"
BACKUP_PATH="$BACKUP_DIR/$BACKUP_FILE"

# Start the backup process

echo $(date "$LOG_FMT") "Starting backup of '$SOURCE_DIR' to '$BACKUP_PATH'" >> "$LOG_FILE"

mkdir -p "$BACKUP_DIR"

CONFIG_BACKUP_DIR_NAME="backup-config"
CONFIG_BACKUP_DIR="$SOURCE_DIR/$CONFIG_BACKUP_DIR_NAME"
rm -rf "$CONFIG_BACKUP_DIR"
mkdir -p "$CONFIG_BACKUP_DIR"

# Save a copy of the current storage mount config file

if [ -f "/etc/fstab" ]; then
  cp -f "/etc/fstab" "$CONFIG_BACKUP_DIR/fstab-config.txt"
fi

# Save a copy of the current Grub config file

if [ -f "/etc/default/grub" ]; then
  cp -f "/etc/default/grub" "$CONFIG_BACKUP_DIR/grub-config.txt"
fi

# Save a copy of the user cron items

if command -v crontab > /dev/null 2>&1 ; then
  crontab -l > "$CONFIG_BACKUP_DIR/crontab-user.txt"
fi

# Save a copy of the file listing, so symlink paths are logged

ls -lah "$SOURCE_DIR" > "$CONFIG_BACKUP_DIR/dir-list-user.txt"

# Save a copy of the Pytxis Terminal config

if command -v /usr/bin/ptyxis > /dev/null 2>&1 ; then
  dconf dump /org/gnome/Ptyxis/ > "$CONFIG_BACKUP_DIR/ptyxis-terminal-config.txt"
fi

# Save a list of all installed Pacman packages

if command -v pacman > /dev/null 2>&1 ; then
  pacman -Qqen > "$CONFIG_BACKUP_DIR/package-list-pacman.txt"
fi

# Save a list of all installed Flatpak packages

if command -v flatpak > /dev/null 2>&1 ; then
  flatpak list --app --columns=application > "$CONFIG_BACKUP_DIR/package-list-flatpak.txt"
fi

# Save a list of all installed Snap packages

if command -v snap > /dev/null 2>&1 ; then
  snap list --unicode=never | tail -n +2 | grep -v 'core\|gnome-\|snapd\|snap-store\|bare\|canonical-livepatch' | awk '{print $1}' > "$CONFIG_BACKUP_DIR/package-list-snap.txt"
fi

# Save a list of all installed Homebrew packages

if command -v brew > /dev/null 2>&1 ; then
  brew leaves > "$CONFIG_BACKUP_DIR/package-list-homebrew.txt"
fi

# Save a list of all Dconf settings

if command -v dconf > /dev/null 2>&1 ; then
  dconf dump / > "$CONFIG_BACKUP_DIR/dconf-user-export.conf"
fi

# Run the ZIP command with specific inclusions and exclusions

cd $SOURCE_DIR

zip \
  --symlinks \
  --recurse-paths \
  --quiet \
  --password "$BACKUP_FILE_PASSWORD" \
  "$BACKUP_PATH" \
  "$CONFIG_BACKUP_DIR_NAME"/* \
  .bashrc \
  .bash_* \
  .profile \
  justfile \
  .face \
  .gitconfig \
  .gitignore \
  .config/mimeapps.list \
  .config/user-dirs.dirs \
  .config/user-dirs.locale \
  .config/autostart/* \
  .config/dconf/* \
  .config/nautilus/* \
  .config/rclone/* \
  .config/systemd/* \
  .config/zed/* \
  .local/bin/* \
  .local/share/applications/* \
  .local/share/backgrounds/* \
  .local/share/gnome-shell/extensions/* \
  .local/share/fonts/* \
  .local/share/sounds/* \
  .dconf/* \
  .gtk-3.0/* \
  .gtk-4.0/* \
  .gnupg/* \
  .password-store/* \
  .pki/* \
  .ssh/* \
  Git/* \
  -x "**/node_modules/*" \
  -x "**/.git/*" \
  -x "**/cache/*" \
  -x "**/.cache/*" \
  -x ".cache/*" \
  -x ".docker/*" \
  -x "**/.venv/*" \
  -x "**/uv/*" \
  -x "*.sock" \
  -x "*.pipe" \
  > /dev/null 2>&1

# Done

rm -rf "$CONFIG_BACKUP_DIR"

echo $(date "$LOG_FMT") "Finished." >> "$LOG_FILE"
