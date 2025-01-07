#!/usr/bin/env bash
clear
source <(wget -qO- https://raw.githubusercontent.com/rdiazlugo/home-docker/refs/heads/master/scripts/common.func)

# App Default Values
APP="immich-photos"
PODMAN_NAME="immich"
PODMAN_IMAGE="docker.io/jc21/nginx-proxy-manager"
PODMAN_TAG="latest"

# Setup
variables
header_info

# Update OS & Install Podman + Composer
podman_composer_install

# Verify if files exists
if [ ! -f docker-compose.yml ]; then
  wget --no-cache -O docker-compose.yml https://raw.githubusercontent.com/rdiazlugo/home-docker/refs/heads/add-immich/photos/docker-compose.yml
fi

if [ ! -f .env ]; then
  wget -O .env https://github.com/immich-app/immich/releases/latest/download/example.env
  # Uncomment to set a new password for the database
  # sed -i "s/DB_PASSWORD=postgres/DB_PASSWORD=$(openssl rand -base64 32 | tr -dc 'A-Za-z0-9' | head -c 32)/" .env
fi

if [ ! -f hwaccel.transcoding.yml ]; then
  wget -O hwaccel.transcoding.yml https://github.com/immich-app/immich/releases/latest/download/hwaccel.transcoding.yml
fi

mkdir -p library model-cache

# Stop, delete current containers and pull latest version
podman-compose pull
podman-compose up -d
podman_images_cleanup
