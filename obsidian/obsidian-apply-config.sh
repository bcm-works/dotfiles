#!/usr/bin/env bash
#
#
# Apply Obsidian Configuration
#  - Makes a backup of your current Obsidian configuration directory
#  - Applies Obsidian configuration from the config directory here to your Obsidian vault config dir
#
#

DIR="$(cd "$(dirname "$0")" && pwd)"

# Setup the message colour characters

blue="\033[0;34m"
green="\033[0;32m"
yellow="\033[0;33m"
red="\033[0;31m"
end="\033[0m"

# Location of the Obsidian vault configuration directory

CONFIG_DIR=$HOME"/Notes/.obsidian"

# Location of the backup directory

BACKUP_DIR="$CONFIG_DIR"_$(date +%Y%m%d%H%M)

# Location of the custom config directory

CUSTOM_DIR="$DIR/config"

# Ask for confirmation from the user before continuing

read -p "$(echo -e $blue"This script will first backup your current Obsidian vault config at '$CONFIG_DIR', then apply the custom config in '$CUSTOM_DIR'. Please close Obsidian first. Continue? (y/n) "$end)" ANSWER
if [ "$ANSWER" != "y" ]; then
  echo -e "${green}Config update cancelled.${end}"
  exit 0
fi

# Backup current config files

echo -e "${yellow}Making backup of current config at '$CONFIG_DIR' to '$BACKUP_DIR'${end}"

mkdir -p "$CONFIG_DIR"

rm -rf "$BACKUP_DIR"
mkdir -p "$BACKUP_DIR"
cp -r "$CONFIG_DIR"/* "$BACKUP_DIR"

# Restore config files

echo -e "${yellow}Applying custom config files${end}"

rm -rf "$CONFIG_DIR"
mkdir -p "$CONFIG_DIR"
cp -r "$CUSTOM_DIR"/* "$CONFIG_DIR"

# Done

echo -e "${green}Custom config applied. You can now open Obsidian again.${end}"
