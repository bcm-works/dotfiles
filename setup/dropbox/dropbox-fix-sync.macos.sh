#!/usr/bin/env bash
#
#
# macOS: Dropbox fix common syncing issues
#
#

sudo chflags -R nouchg ~/Dropbox ~/.dropbox ~/.dropbox-master
sudo chown "$USER" "$HOME"
sudo chown -R "$USER" ~/Dropbox ~/.dropbox
sudo chmod -RN ~/.dropbox ~/Dropbox
chmod -R u+rw ~/Dropbox ~/.dropbox
