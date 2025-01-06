#!/usr/bin/env bash
clear
source <(wget -qO- https://raw.githubusercontent.com/rdiazlugo/home-docker/refs/heads/master/scripts/common.func)

# App Default Values
APP="AI Chat"
PODMAN_NAME="open-webui"
PODMAN_IMAGE="ghcr.io/open-webui/open-webui"
PODMAN_TAG="main"

# Setup
variables
header_info

# Update OS & Install Podman
podman_install
# Check for OpenAI API Key
check_environment_variable "OPENAI_API_KEY"

# Stop, delete current containers and pull latest version
podman_container_maintenance

# Create data folders if not existent
mkdir -p data

# Run with Podman
podman run -d \
  --name "$PODMAN_NAME" \
  --hostname "$PODMAN_NAME" \
  --env-file .env \
  --network host \
  --restart always \
  -v ./data:/app/backend/data \
  "$PODMAN_IMAGE:$PODMAN_TAG"

podman_images_cleanup
set_reboot_cron
