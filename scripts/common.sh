#!/usr/bin/env bash

variables() {
  LC_APP=$(echo ${APP,,} | tr -d ' ') # This function sets the LC_APP variable by converting the value of the APP variable to lowercase and removing any spaces.
  var_app="$LC_APP-install"
  INSTALLER_PATH="~/$var_app.sh"
  echo "LC_APP $LC_APP"
  echo "var_app $var_app"
  echo "INSTALLER_PATH $INSTALLER_PATH"
}

deb_upgrade() {
  echo ">> Updating OS..."
  apt update &>/dev/null
  apt upgrade -y &>/dev/null
  echo "<< Updated successfully!"
}

# Prints info with ASCII
# taken from https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.func
header_info() {
  if [ -f /etc/debian_version ]; then
    # Debian/Ubuntu
    apt-get install -y figlet &> /dev/null
  elif [ -f /etc/alpine-release ]; then
    # Alpine Linux
    apk add --no-cache figlet ncurses &> /dev/null
    export TERM=xterm
  else
    echo "Unsupported OS"
    return 1
  fi

  term_width=$(tput cols 2>/dev/null || echo 120)  # Fallback to 120 columns
  ascii_art=$(figlet -f slant -w "$term_width" "$APP")
  clear
  cat <<EOF
$ascii_art
EOF
}

set_reboot_cron() {
  if crontab -l | grep -q "@reboot $INSTALLER_PATH"; then
    echo "Crontab already contains the script."
  else
    (crontab -l 2>/dev/null; echo "@reboot $INSTALLER_PATH") | crontab -
    echo "Added crontab to run on startup"
  fi
}

podman_install() {
  apt install -y podman docker-compose
}

podman_container_maintenance() {
  # Pull latest images
  podman pull "$PODMAN_IMAGE"
  # Stop previously running containers
  podman stop -i "$PODMAN_NAME"
  # Remove previously existing containers
  podman rm -i "$PODMAN_NAME"
}

