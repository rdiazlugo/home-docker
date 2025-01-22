#!/usr/bin/env bash
clear
source <(wget -qO- https://raw.githubusercontent.com/rdiazlugo/home-docker/refs/heads/master/scripts/common.func)

# App Default Values
APP="PostgreSQL"

# Setup
variables
header_info

run_db_command() {
  psql -U postgres -h localhost -d postgres -c "$1"
}

# Download Apt Package
wget https://github.com/tensorchord/pgvecto.rs/releases/download/v0.4.0/vectors-pg17_0.4.0_amd64.deb
apt install ./vectors-pg17_0.4.0_amd64.deb

run_db_command 'ALTER SYSTEM SET shared_preload_libraries = "vectors.so"'
run_db_command 'ALTER SYSTEM SET search_path TO "$user", public, vectors'
systemctl restart postgresql.service
# reboot maybe?

run_db_command 'DROP EXTENSION IF EXISTS vectors;'
run_db_command 'CREATE EXTENSION vectors;'
