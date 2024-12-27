#!/usr/bin/env bash
echo ">> Updating OS and installing curl"
apt update -qq
apt upgrade -y -qq
apt install -y -qq curl
echo "<< Base setup done"

source <(curl -s https://raw.githubusercontent.com/rdiazlugo/home-docker/refs/heads/master/scripts/common.func)

# App Default Values
APP="AdGuard"
PODMAN_NAME="adguard"
PODMAN_IMAGE="docker.io/adguard/adguardhome"
PODMAN_TAG="latest"

# Setup
variables

# Update OS & Install Podman
podman_install

#
podman_container_maintenance
# Create data folder if it doesn't exists
mkdir -p data/work
mkdir -p data/conf

# Install Adguard
podman run -d \
  --name "$PODMAN_NAME" \
  --network host \
  --restart unless-stopped \
  -v ./data/work:/opt/adguardhome/work \
  -v ./data/conf:/opt/adguardhome/conf \
  "$PODMAN_IMAGE:$PODMAN_TAG"

set_reboot_cron
