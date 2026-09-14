#!/usr/bin/env bash
#
# Run the iCloud Photos Downloader script
#  - Requires Linux
#  - Requires the "icloudpd" binary from https://github.com/icloud-photos-downloader/icloud_photos_downloader
#  - Requires 1Password to be installed
#  - First login manually and complete any two factor auth via: ./icloudpd-xxx --username xxx --auth-only
#

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

LOG_DATE_FORMAT="+%Y%m%d-%H%M%S"
LOG_FILE="$SCRIPT_DIR/backup-icloud-photos.log"
touch "$LOG_FILE"

cp --update=none "$SCRIPT_DIR/.backup-icloud-photos.sample.env" "$SCRIPT_DIR/.backup-icloud-photos.env"
source "$SCRIPT_DIR/.backup-icloud-photos.env"

mkdir -p "$BACKUP_DIR"

# To update this, get the newer version with the name of 'icloudpd-xxxx-linux-amd64',
# copy that file in to this dir, named as set below line, and 'chmod +x' that file

ICLOUDPD_BIN="$SCRIPT_DIR/backup-icloud-photos-icloudpd"

# Run the command using the required parameters

$ICLOUDPD_BIN \
  --username $ICLOUD_USERNAME \
  --password $ICLOUD_PASSWORD \
  --auto-delete \
  --directory $BACKUP_DIR \
  --cookie-directory $ICLOUDPD_AUTH_DIR \
  > "$LOG_FILE"
