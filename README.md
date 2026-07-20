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
  - `profile.png`: Square PNG image to use for your user profile image
  - `wallpaper.jpg`: JPG image to use for desktop wallpaper
  - `crontab.txt`: Crontab config, add your current setup by saving the output of `crontab -l`
- Run [bin/setup.sh](bin/setup.sh): `bash ./bin/setup.sh`
