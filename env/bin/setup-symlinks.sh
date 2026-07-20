#!/usr/bin/env bash
#
#
# Setup symlinks for a new Linux User
#   - Requires 'git' package and Git Config applied
#   - Requires Steam installed via Flatpak
#   - Other than the above, assumes a clean Linux install
#
#

REPO="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO"
DOTFILES="/home/media/Git/dotfiles"
source "$DOTFILES/bin/.helper.sh"
OS="$(os)"
OS_CLEAN="$(os_clean)"
bash "$REPO/bin/backup.sh"

SOURCE_DIR_SYNCED="/home/media/Sync"
SOURCE_DIR_GIT="/home/media/Git"
SOURCE_DIR_DOWNLOADS="/home/media/Downloads"
SOURCE_DIR_STEAM="/home/media/Steam"
SOURCE_DIR_MEDIA="/home/media"

TARGET_DIR="$HOME"

# Ubuntu 26
#ICON_DIR="/usr/share/icons/Yaru-prussiangreen-dark/256x256@2x/places"
#ICON_EXT="png"

# Fedora 44
ICON_DIR="/usr/share/icons/Adwaita/scalable/places"
ICON_EXT="svg"

# Setup Git dirs and symlinks
#   - Assumes some Git repos are cloned inside of the 'git' dir already
ln -s "$SOURCE_DIR_GIT" "$TARGET_DIR/Git"
ln -s "$SOURCE_DIR_GIT/dotfiles" "$TARGET_DIR/Dotfiles"
#gio set -t string "$TARGET_DIR/Git" metadata::custom-icon "file://$ICON_DIR/folder-remote.$ICON_EXT"
#gio set -t string "$TARGET_DIR/Dotfiles" metadata::custom-icon "file://$ICON_DIR/folder-templates.$ICON_EXT"

# Setup Downloads
gio trash "$TARGET_DIR/Downloads"
ln -s "$SOURCE_DIR_DOWNLOADS" "$TARGET_DIR/Downloads"

# Setup Synced link
gio trash "$TARGET_DIR/Sync"
ln -s "$SOURCE_DIR_SYNCED" "$TARGET_DIR/Sync"

# Setup Steam symlinks
gio trash "$HOME/.local/share/Steam/steamapps/common"
ln -s "$SOURCE_DIR_STEAM/Games" "$HOME/.local/share/Steam/steamapps/common"
gio trash "$HOME/.local/share/Steam/steamapps/compatdata"
ln -s "$SOURCE_DIR_STEAM/Data" "$HOME/.local/share/Steam/steamapps/compatdata"

# Setup Sync subdir links
#gio set -t string "$TARGET_DIR" metadata::custom-icon "file://$ICON_DIR/folder-remote.$ICON_EXT"
gio trash "$TARGET_DIR/Desktop"
ln -s "$SOURCE_DIR_SYNCED/Documents/Desktop" "$TARGET_DIR/Desktop"
gio trash "$TARGET_DIR/Documents"
ln -s "$SOURCE_DIR_SYNCED/Documents" "$TARGET_DIR/Documents"
gio trash "$TARGET_DIR/Music"
ln -s "$SOURCE_DIR_SYNCED/Music" "$TARGET_DIR/Music"
gio trash "$TARGET_DIR/Pictures"
ln -s "$SOURCE_DIR_SYNCED/Media" "$TARGET_DIR/Pictures"
gio trash "$TARGET_DIR/Public"
ln -s "$SOURCE_DIR_SYNCED/Documents/Shared" "$TARGET_DIR/Public"
gio trash "$TARGET_DIR/Templates"
ln -s "$SOURCE_DIR_SYNCED/Documents/Templates" "$TARGET_DIR/Templates"
gio trash "$TARGET_DIR/Videos"
ln -s "$SOURCE_DIR_SYNCED/Media" "$TARGET_DIR/Videos"
gio trash "$TARGET_DIR/Projects"
ln -s "$SOURCE_DIR_SYNCED/Documents/Work" "$TARGET_DIR/Projects"
#gio set -t string "$TARGET_DIR/Projects" metadata::custom-icon "file://$ICON_DIR/folder-templates.$ICON_EXT"

# Setup Backups
ln -s "$SOURCE_DIR_SYNCED/Backups" "$TARGET_DIR/Backups"
#gio set -t string "$TARGET_DIR/Backups" metadata::custom-icon "file://$ICON_DIR/folder-remote.$ICON_EXT"

# Setup Source Dir links and folder icons
gio trash "$TARGET_DIR/Media"
ln -s "$SOURCE_DIR_MEDIA" "$TARGET_DIR/Media"
#gio set -t string "$TARGET_DIR/Media" metadata::custom-icon "file://$ICON_DIR/folder-remote.$ICON_EXT"

# Restore the 'user-dirs' file

cp -n "$HOME/.config/user-dirs.dirs" "$HOME/.config/user-dirs.dirs.old"

echo 'XDG_DESKTOP_DIR="$HOME/Desktop"' > "$HOME/.config/user-dirs.dirs"
echo 'XDG_DOWNLOAD_DIR="$HOME/Downloads"' >> "$HOME/.config/user-dirs.dirs"
echo 'XDG_TEMPLATES_DIR="$HOME/Templates"' >> "$HOME/.config/user-dirs.dirs"
echo 'XDG_PUBLICSHARE_DIR="$HOME/Public"' >> "$HOME/.config/user-dirs.dirs"
echo 'XDG_DOCUMENTS_DIR="$HOME/Documents"' >> "$HOME/.config/user-dirs.dirs"
echo 'XDG_MUSIC_DIR="$HOME/Music"' >> "$HOME/.config/user-dirs.dirs"
echo 'XDG_PICTURES_DIR="$HOME/Pictures"' >> "$HOME/.config/user-dirs.dirs"
echo 'XDG_VIDEOS_DIR="$HOME/Videos"' >> "$HOME/.config/user-dirs.dirs"

# List home dir to show results
ls -lah "$TARGET_DIR"
