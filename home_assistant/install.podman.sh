#!/usr/bin/env bash
clear
source <(wget -qO- https://raw.githubusercontent.com/rdiazlugo/home-docker/refs/heads/add-home-assistant/scripts/common.func)

# App Default Values
APP="Home Assistant"

# Setup
variables
header_info

# Update OS & Install Podman
podman_install

# Create .env file from example if not existent
if [ ! -f .env ]; then
  wget -O .env https://raw.githubusercontent.com/rdiazlugo/home-docker/refs/heads/add-home-assistant/home_assistant/.env.example
fi

# Create .env file from example if not existent
if [ ! -f docker-compose.yml ]; then
  wget -O docker-compose.yml https://raw.githubusercontent.com/rdiazlugo/home-docker/refs/heads/add-home-assistant/home_assistant/docker-compose.yml
fi

# Check if .env file exists
check_file_exists ".env"

mkdir -p ha_config
mkdir -p esphome_config

# Pull latest version
podman-compose pull
# Stop and remove older version
podman-compose down
# Start the container
podman-compose up -d

set_reboot_cron
podman_images_cleanup
