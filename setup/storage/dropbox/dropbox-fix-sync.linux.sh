#!/usr/bin/env bash
#
#
# Linux: Dropbox fix common syncing issues
#
#

sudo chown "$USER" "$HOME"
sudo chown -R "$USER" ~/Dropbox ~/.dropbox
sudo chattr -R -i ~/Dropbox
sudo chmod -R u+rw ~/Dropbox ~/.dropbox
