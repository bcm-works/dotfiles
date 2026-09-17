# Dotfiles

Configuration files, programs, packages and scripts I use for personal, gaming and software development use.

- **[ai](ai/)** - AI docs and setup scripts
- **[apps](apps/)** - App setup scripts and custom config
- **[apps/obsidian](apps/obsidian/)** - Custom [Obsidian](https://obsidian.md/) config and example note vault
- **[apps/zed](apps/zed/)** - Custom [Zed](https://zed.dev/) setup and config
- **[apps/vscode](apps/vscode/)** - Custom [VS Code](https://code.visualstudio.com/) setup and config
- **[dev](dev/)** - Software development setup scripts and config
- **[dev/bin](dev/bin/)** - Scripts to support software development
- **[dev/templates](dev/templates/)** - Custom templates to simplify new software project creation
- **[games](games/)** - Setup packages and config to improve performance in games
- **[linux](linux/)** - Linux setup and config
- **[tools](tools/)** - Package managers and system utility scripts
- **[tools/docker.sh](tools/docker.sh)** - [Docker](https://docker.com/) setup
- **[tools/homebrew](tools/homebrew/)** - [Homebrew](https://brew.sh/) setup
- **[backup.sh](backup.sh)** - Create a new config backup in the Git Ignored `config/backups` directory
- **[setup.sh](setup.sh)** - Initial setup script
- **[save.sh](save.sh)** - Save current package names to the package list files
- **[utils.sh](utils.sh)** - Helper functions for setup scripts in this repo

## Initial Setup

- Copy [.env.sample](.env.sample) to `.env`
- Edit `.env` to suit your needs and optionally set a custom config directory location, note that this file is ignored by Git
- **Optional** - Save your installed package names to the package list files by running `bash ./save.sh`
- Setup your `config` directory (Git Ignored):
	- `packages/flatpak.list.txt` - Flatpak apps list
	- `packages/gnome-extension.list.txt` - Gnome Shell Extensions list
	- `packages/pacman.list.txt` - Pacman packages list
  - `profile.png` - The PNG image to use for your user profile image
  - `wallpaper.jpg` - The JPG image to use for your desktop wallpaper
  - `crontab.txt` - Crontab config, update with `crontab -l > ./config/crontab.txt`
- Run the [setup script](setup.sh) - `bash ./setup.sh`

