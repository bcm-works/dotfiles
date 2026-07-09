# Gnome: Fix a tray icon showing as "..." instead of icon

First follow this process to get the Tray Icon Id
https://github.com/ubuntu/gnome-shell-extension-appindicator/issues/355#issuecomment-1214409509

Then install the required Gnome Shell Extension:
https://extensions.gnome.org/extension/615/appindicator-support/

In that extension's settings, use the Tray Icon Id from above setup a custom icon for that.
Use the Tray Icon Id as the value for both Indicator ID and Attention Icon Name.

Set the Icon Name field to the full path to an image file to show for the tray icon instead.

Directories that contain icons:

- ~/.local/share/icons
- /var/lib/flatpak/exports/share/icons
