#!/usr/bin/env bash
#
#
# Backup a directory as a password-protected ZIP file
#  - Accepts optional parameter of the env file name, which must be in this script's dir
#  - Include and exclude rules (starting with "-x") are set in the "zip" command below
#  - Saves symlinks as links, not as directories
#  - Saves output messages to the file set in LOG_FILE
#  - If your system's scheduler is cron, setup by running 'crontab -e', then adding a line:
#    0 19 * * * bash /home/username/dotfiles/storage/backup-linux-dir/backup-linux-dir.sh .env-file-name.env
#  - If your system's scheduler is systemd, refer to 'backup-linux-dir.service'
#
#

DIR="$(dirname "$(readlink -f "$0")")"
REPO="$(cd "$(dirname "$0")/../.." && pwd)"
source "$REPO/bin/.helper.sh"

LOG_FILE="$DIR/backup-linux-dir.log"
LOG_FMT="+%Y-%m-%d %H:%M:%S"

cd "$DIR"
touch "$LOG_FILE"

# If the first parameter sent to this script is set, use that as the ENV file name,
# or fallback to '.backup-linux-dir.env'.
ENV_FILE_NAME="${1:-.backup-linux-dir.env}"
ENV_FILE_PATH="$DIR/$ENV_FILE_NAME"

# Exit early if the ENV file isn't found in the current directory
if [ ! -f "$ENV_FILE_PATH" ]; then
  echo $(date "$LOG_FMT") "Error - ENV file not found: $ENV_FILE_PATH" >> "$LOG_FILE"
  echo $(date "$LOG_FMT") "Info - Sample ENV file at $DIR/.backup-linux-dir.sample.env" >> "$LOG_FILE"
  exit 1
fi

source "$ENV_FILE_PATH"

mkdir -p "$BACKUP_DIR"

BACKUP_FILE="${BACKUP_FILE_PREFIX}_$(date +%Y%m%d-%H%M%S).zip"
BACKUP_FILE_PATH="$BACKUP_DIR/$BACKUP_FILE"

# Exit if the source directory doesn't exist

if [ ! -d $SOURCE_DIR ]; then
  echo $(date "$LOG_FMT") "Error - Source directory ($SOURCE_DIR) not found, please check the path in the script" >> "$LOG_FILE"
  exit 0
fi

# Start backup process

echo $(date "$LOG_FMT") "Info - Starting backup of '$SOURCE_DIR' to '$BACKUP_FILE_PATH' using '$ENV_FILE_NAME'" >> "$LOG_FILE"

mkdir -p "$BACKUP_DIR"

# Run the ZIP command with specific inclusions and exclusions

cd $SOURCE_DIR

zip \
  --symlinks \
  --recurse-paths \
  --quiet \
  --password "$BACKUP_FILE_PASSWORD" \
  "$BACKUP_FILE_PATH" \
  . \
  -x "**/node_modules/*" \
  -x "**/cache/*" \
  -x "**/.cache/*" \
  -x ".cache/*" \
  -x ".docker/*" \
  -x "**/.venv/*" \
  -x "**/uv/*" \
  -x "*.sock" \
  -x "*.pipe" > /dev/null 2>&1

# Done

echo $(date "$LOG_FMT") "Info - Finished." >> "$LOG_FILE"
