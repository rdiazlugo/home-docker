#!/usr/bin/env bash
clear
source <(wget -qO- https://raw.githubusercontent.com/rdiazlugo/home-docker/refs/heads/master/scripts/common.func)

# App Default Values
APP="n8n"
PODMAN_NAME="n8n"
PODMAN_IMAGE="docker.n8n.io/n8nio/n8n"

# Setup
variables
header_info

# Update OS & Install Podman
podman_install

# Stop, delete current containers and pull latest version
podman_container_maintenance

# Check if .env file exists
check_file_exists ".env"

# Create data volumes
DATA_VOLUME="${APP}_data"
podman_create_volume "$DATA_VOLUME"

# Run with Podman
podman run -d \
  --name "$PODMAN_NAME" \
  --hostname "$PODMAN_NAME" \
  --env-file .env \
  --network host \
  --restart always \
  -v "${DATA_VOLUME}:/home/node/.n8n" \
  "$PODMAN_IMAGE"

set_reboot_cron
podman_images_cleanup
