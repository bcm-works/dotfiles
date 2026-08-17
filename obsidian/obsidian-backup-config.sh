#!/usr/bin/env bash
#
#
# Backup Obsidian Configuration
#  - Makes a copy of your Obsidian vault config to the config directory here
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

# Location of the config directory here

UPDATE_DIR="$DIR/config"

# Ask for confirmation from the user before continuing

read -p "$(echo -e $blue"This script will backup your Obsidian config from '$CONFIG_DIR' to '$DIR/config'. Continue? (y/n) "$end)" ANSWER
if [ "$ANSWER" != "y" ]; then
  echo -e "${green}Backup cancelled${end}"
  exit 0
fi

# Backup current config files

echo -e "${yellow}Updating current config from files in $CONFIG_DIR${end}"

mkdir -p "$CONFIG_DIR"

rm -rf "$UPDATE_DIR"
mkdir -p "$UPDATE_DIR"
cp -r "$CONFIG_DIR"/* "$UPDATE_DIR"

# Commit config updates

echo -e "${yellow}Committing changes to 'config' directory${end}"

git add "config/*"
git commit -m "Update config"

# Done

echo -e "${green}Backup completed and commit added, check the commit before pushing.${end}"
