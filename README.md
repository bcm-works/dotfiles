# Dotfiles

Configuration files, programs, packages and scripts I use for personal, gaming and software development use.

- **[.prototypes](.prototypes/)**: Ideas and half-built prototypes 
- **[ai](ai/)**: AI docs and setup scripts
- **[bin](bin/)**: Bash utility and backup scripts
- **[bin/setup.sh](bin/setup.sh)**: Initial setup script
- **[dev](dev/)**: Setup scripts and config for software development tools
- **[dev/templates](dev/templates/)**: Custom templates to simplify new software project creation
- **[linux](linux/)**: Linux setup and customisation scripts
- **[obsidian](obsidian/)**: Custom [Obsidian](https://obsidian.md/) configuration and example note vault

## Initial Setup

- Copy [.sample.env](.sample.env) to `.env`
- Edit `.env` to suit your needs and optionally set a custom config directory location
- Setup your `config` directory (git ignored):
	- `packages/endeavouros.list.txt`: EndeavourOS Pacman packages list
	- `packages/flatpak.list.txt`: Flatpak apps list
	- `packages/gnome-extension.list.txt`: Gnome Shell Extensions list
  - `profile.png`: The PNG image to use for your user profile image
  - `wallpaper.jpg`: The JPG image to use for your desktop wallpaper
  - `crontab.txt`: Crontab config, update with `crontab -l > ./config/crontab.txt`
- Run the [initial setup script](bin/setup.sh): `bash ./bin/setup.sh`

## Save Package Lists

- Flatpak applications: `flatpak list --app --columns=application | tail -n +1 > ./config/packages/flatpak.list.txt`
- Gnome Shell extensions: `gnome-extensions list --user > ./config/packages/gnome-extension.list.txt`
- EndeavourOS Pacman packages: `pacman -Qqm > ./config/packages/endeavouros.list.txt`
