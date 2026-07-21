# Dotfiles

Configuration files, programs, packages and scripts I use for personal, gaming and software development use.

- **[ai](ai/)**: AI docs and setup scripts
- **[bin](bin/)**: Bash utility scripts
- **[bin/setup.sh](bin/setup.sh)**: Interactive initial setup script
- **[setup](setup/)**: Setup scripts
- **[templates](templates/)**: Custom templates to simplify new project creation

## Initial Setup

- Copy [.sample.env](config/.sample.env) to `.env`
- Edit `.env` to suit your needs and optionally set a custom config directory location
- Setup your `config` directory (git ignored):
	- `gnome/extension.list.txt`: Gnome Shell Extensions, update with `gnome-extensions list --user > config/gnome/extension.list.txt`
	- `flatpak/flatpak.list.txt`: Flatpak apps, update with `flatpak list --app --columns=application | tail -n +1 > config/flatpak/flatpak.list.txt`
  - `profile.png`: The PNG image to use for your user profile image
  - `wallpaper.jpg`: The JPG image to use for your desktop wallpaper
  - `crontab.txt`: Crontab config, update with `crontab -l > config/crontab.txt`
- Run [bin/setup.sh](bin/setup.sh): `bash ./bin/setup.sh`
