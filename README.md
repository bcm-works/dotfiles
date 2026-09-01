# Dotfiles

Configuration files, programs, packages and scripts I use for personal, gaming and software development use.

- **[.prototypes](.prototypes/)**: Ideas and half-built prototypes 
- **[ai](ai/)**: AI docs and setup scripts
- **[bin](bin/)**: Bash scripts
- **[bin/utils.sh](bin/utils.sh)**: Bash helper functions for setup scripts
- **[dev](dev/)**: Setup scripts and config for software development tools
- **[dev/templates](dev/templates/)**: Custom templates to simplify new software project creation
- **[linux](linux/)**: Linux setup and customisation scripts
- **[obsidian](obsidian/)**: Custom [Obsidian](https://obsidian.md/) configuration and example note vault
- **[backup.sh](backup.sh)**: Create a new config backup in the Git Ignored `config/backups` directory
- **[setup.sh](setup.sh)**: Initial setup script
- **[save.sh](save.sh)**: Save current package names to the package list files

## Initial Setup

- Copy [.sample.env](.sample.env) to `.env`
- Edit `.env` to suit your needs and optionally set a custom config directory location
- **Optional** - Save your installed package names to the package list files by running `bash ./save.sh`
- Setup your `config` directory (Git Ignored):
	- `packages/flatpak.list.txt`: Flatpak apps list
	- `packages/gnome-extension.list.txt`: Gnome Shell Extensions list
	- `packages/pacman.list.txt`: Pacman packages list
  - `profile.png`: The PNG image to use for your user profile image
  - `wallpaper.jpg`: The JPG image to use for your desktop wallpaper
  - `crontab.txt`: Crontab config, update with `crontab -l > ./config/crontab.txt`
- Run the [setup script](setup.sh): `bash ./setup.sh`

