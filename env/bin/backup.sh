#!/usr/bin/env bash
#
#
# Backup current user config files
#
#

REPO="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO"
DOTFILES="/home/media/Git/dotfiles"
source "$DOTFILES/bin/.helper.sh"
OS="$(os)"
OS_CLEAN="$(os_clean)"

NOW=$(date "+%Y%m%d-%H%M%S")
BACKUPS="$REPO/backups/$NOW"

mkdir -p "$BACKUPS"

crontab -l > "$BACKUPS/crontab.bak"

cp "$HOME/".bash* "$BACKUPS"
cp "$HOME/".git* "$BACKUPS"
cp -r "$HOME/".vim* "$BACKUPS"
cp -r "$HOME/".ssh "$BACKUPS"

[ -e "$HOME/.env.local" ] && cp "$HOME/.env.local" "$BACKUPS"
[ -e "$HOME/justfile" ] && cp "$HOME/justfile" "$BACKUPS"

if [ -f "$HOME/.face" ]; then
  cp "$HOME/.face" "$BACKUPS"
fi
if [ -f "$HOME/.face.icon" ]; then
  cp "$HOME/.face.icon" "$BACKUPS"
fi
if [ -f "$HOME/profile.png" ]; then
  cp "$HOME/profile.png" "$BACKUPS"
fi
if [ -f "/var/lib/AccountsService/icons/$USER" ]; then
  cp "/var/lib/AccountsService/icons/$USER" "$BACKUPS"
fi

mkdir -p "$BACKUPS/.config"
cp -r "$HOME/.config/user-dirs.dirs" "$BACKUPS/.config"
cp -r "$HOME/.config/user-dirs.locale" "$BACKUPS/.config"

success "New backup directory created at $BACKUPS"
