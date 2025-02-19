#!/usr/bin/env bash
clear
source <(wget -qO- https://raw.githubusercontent.com/rdiazlugo/home-docker/refs/heads/master/scripts/common.func)

# App Default Values
APP="Nginx Proxy Manager"
PODMAN_NAME="proxy"
PODMAN_IMAGE="docker.io/jc21/nginx-proxy-manager"
PODMAN_TAG="latest"
INSTALLER_PATH="/root/install.sh"

# Setup
variables
header_info

# Update OS & Install Podman
podman_install

# Stop, delete current containers and pull latest version
podman_container_maintenance
# Create data folders if not existent
mkdir -p data letsencrypt

# Run with Podman
podman run -d \
  --name "$PODMAN_NAME" \
  --hostname "$PODMAN_NAME" \
  --network host \
  --restart always \
  -v ./data:/data \
  -v ./letsencrypt:/etc/letsencrypt \
  "$PODMAN_IMAGE:$PODMAN_TAG"

set_reboot_cron
podman_images_cleanup
