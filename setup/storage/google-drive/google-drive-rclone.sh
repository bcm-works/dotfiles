#!/usr/bin/env bash
#
# Setup a background local bidirectional synced copy of a Rclone remote for Google Drive
#   - WARNING: The "rclone bisync" command will delete local files if they're removed
#     from the remote! Please confirm this is what you're after, more info at:
#     https://rclone.org/commands/rclone_bisync/
#   - Requires a Linux system with the rclone package installed
#   - Requires an existing Rclone remote config, more info at:
#     https://rclone.org/commands/rclone_config
#   - Force quit all Rclone processes: sudo killall rclone
#   - View the web GUI to see progress of rclone syncs: rclone rcd --rc-web-gui
#   - More info at https://rclone.org/drive/
#

DIR=$(dirname "$(realpath "$0")")

LOG_FILE="$DIR/google-drive-rclone.log"
touch "$LOG_FILE"

cp --update=none "$DIR/google-drive-rclone.env.sample" "$DIR/google-drive-rclone.env"
source "$DIR/google-drive-rclone.env"

# Run the rclone bisync command in the background

mkdir -p "$HOME/.google-drive-rclone"

nohup rclone bisync \
  "$LOCAL_SYNC_DIR" \
  "$RCLONE_REMOTE_NAME:/" \
  --workdir "$HOME/.google-drive-rclone" \
  --transfers 15 \
  --ignore-listing-checksum \
  --resync-mode newer \
  --no-slow-hash \
  --recover \
  --resilient \
  --force \
  --inplace \
  --copy-links \
  --create-empty-src-dirs \
  --conflict-resolve newer \
  --conflict-loser delete \
  --refresh-times \
  --backup-dir1 "/home/$LOCAL_SYNC_USER/.local/share/Trash/files" \
  --drive-use-trash=true \
  --delete-after \
  --human-readable \
  --contimeout 1m \
  --timeout 1m \
  --log-level INFO \
  --log-file "$LOG_FILE" \
  > /dev/null 2>&1 &
