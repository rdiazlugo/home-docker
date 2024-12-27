#!/usr/bin/env bash
clear
source <(wget -qO- https://raw.githubusercontent.com/rdiazlugo/home-docker/refs/heads/master/scripts/common.func)

# App Default Values
APP="NGINX Proxy Manager"
PODMAN_NAME="proxy"
PODMAN_IMAGE="docker.io/jc21/nginx-proxy-manager"
PODMAN_TAG="latest"

# Setup
variables
header_info

# Update OS & Install Podman
podman_install

# Stop, delete current containers and pull latest version
podman_container_maintenance

mkdir -p data certs

podman run -d \
  --name "$PODMAN_NAME" \
  --network host \
  --restart always \
  -v ./data:/data \
  -v ./certs:/etc/letsencrypt \
  "$PODMAN_IMAGE:$PODMAN_TAG"

set_reboot_cron
