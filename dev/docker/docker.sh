#!/usr/bin/env bash
#
#
# Docker setup
#
#

source "$HOME/Dotfiles/bin/utils.sh"
REPO="$(dir_repo)"
DIR="$(dir_this)"
OS="$(os)"
cd "$REPO"

if [[ "$OS" == "macOS" || "$OS" == "Windows" ]]; then
  error "This script requires Linux."
  exit 0
fi

if [[ "$OS" == "EndeavourOS" ]]; then
  warn "Requesting sudo"
  sudo -v

  info "Installing Podman and Docker packages"
  yay -Syu --noconfirm \
    podman \
    podman-compose \
    podman-docker \
    podman-desktop > /dev/null 2>&1

  info "Configuring Docker registry and container config defaults"
  cp -n "$DIR/registries.conf" "$HOME/.config/containers/registries.conf"
  cp -n "$DIR/containers.conf" "$HOME/.config/containers/containers.conf"

  info "Suppressing notices about running Docker features via Podman"
  sudo touch /etc/containers/nodocker

  info "Add user subids to improve rootless Docker support in Podman"
  sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 $USER

  exit 0
fi

if [[ "$OS" == "Fedora" ]]; then
  # Request Sudo
  sudo -v

  # Install Docker CLI
  sudo dnf config-manager addrepo --from-repofile https://download.docker.com/linux/fedora/docker-ce.repo
  sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin > /dev/null 2>&1
  sudo systemctl enable --now docker > /dev/null 2>&1

  # Setup Docker
  sudo groupadd docker
  sudo usermod -aG docker $USER

  # Install Docker Desktop
  DOCKER_RPM="$HOME/Downloads/temp-docker-desktop-x86_64.rpm"
  rm -rf "$DOCKER_RPM"
  curl --output "$DOCKER_RPM" "https://desktop.docker.com/linux/main/amd64/docker-desktop-x86_64.rpm" > /dev/null 2>&1
  sudo dnf -y install "$DOCKER_RPM" > /dev/null 2>&1
  rm -rf "$DOCKER_RPM"

  exit 0
fi

if [ "$(os_debian_based)" ]; then
  # Request Sudo
  sudo -v

  # Add the Docker packages repository and official GPG key
  sudo apt install -y ca-certificates curl > /dev/null 2>&1
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc > /dev/null 2>&1
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  # Add the repository to Apt sources
  sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

  # Install Docker and standard plugins
  sudo apt -qq --assume-yes install \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin \
    docker-ce-rootless-extras > /dev/null 2>&1

  # Give this user privileged Docker access
  sudo usermod -aG docker ${USER}

  # Limit log size to avoid running out of disk
  echo '{"log-driver":"json-file","log-opts":{"max-size":"10m","max-file":"5"}}' | sudo tee /etc/docker/daemon.json

  # Install Docker Desktop
  DOCKER_DEB="$HOME/Downloads/temp-docker-desktop-amd64.deb"
  rm -rf "$DOCKER_DEB"
  curl --output "$DOCKER_DEB" "https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb" > /dev/null 2>&1
  sudo apt -qq --assume-yes install "$DOCKER_DEB" > /dev/null 2>&1
  rm -rf "$DOCKER_DEB"

  exit 0
fi
