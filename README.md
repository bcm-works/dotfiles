# Dotfiles

Configuration files, programs, packages and scripts I use for personal, gaming and software development use.

- **[ai](ai/)**: AI docs and setup scripts
- **[bin](bin/)**: Bash utility scripts
- **[bin/setup.sh](bin/setup.sh)**: Interactive initial setup script
- **[setup](setup/)**: Setup scripts
- **[templates](templates/)**: Custom templates to simplify new project creation

## Initial Setup

- Copy [.sample.env](.sample.env) to `.env`
- Edit `.env` to suit your needs and optionally set a custom config directory location
- Setup your `config` directory (git ignored):
	- `packages/endeavouros.list.txt`: EndeavourOS Pacman packages list
	- `packages/flatpak.list.txt`: Flatpak apps list
	- `packages/gnome-extension.list.txt`: Gnome Shell Extensions list
  - `profile.png`: The PNG image to use for your user profile image
  - `wallpaper.jpg`: The JPG image to use for your desktop wallpaper
  - `crontab.txt`: Crontab config, update with `crontab -l > config/crontab.txt`
- Run [bin/setup.sh](bin/setup.sh): `bash ./bin/setup.sh`

## Save Package Lists

- Flatpak applications: `flatpak list --app --columns=application | tail -n +1 > config/packages/flatpak.list.txt`
- Gnome Shell extensions: `gnome-extensions list --user > config/packages/gnome-extension.list.txt`
- EndeavourOS Pacman packages: `pacman -Qqm > config/packages/endeavouros.list.txt`
