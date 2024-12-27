#!/usr/bin/env bash
clear
source <(wget -qO- https://raw.githubusercontent.com/rdiazlugo/home-docker/refs/heads/master/scripts/common.func)

# App Default Values
APP="AdGuard"
PODMAN_NAME="adguard"
PODMAN_IMAGE="docker.io/adguard/adguardhome"
PODMAN_TAG="latest"

# Setup
variables
header_info

# Update OS & Install Podman
podman_install

# Stop, delete current containers and pull latest version
podman_container_maintenance

# Create data folders if not existent
mkdir -p data/work
mkdir -p data/conf

# Run with Podman
podman run -d \
  --name "$PODMAN_NAME" \
  --hostname "$PODMAN_NAME" \
  --network host \
  --restart unless-stopped \
  -v ./data/work:/opt/adguardhome/work \
  -v ./data/conf:/opt/adguardhome/conf \
  "$PODMAN_IMAGE:$PODMAN_TAG"

set_reboot_cron
