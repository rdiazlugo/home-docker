# Home Assistant and ESPHome

Install by running this command in a terminal

### Podman
`wget -O install.sh https://raw.githubusercontent.com/rdiazlugo/home-docker/refs/heads/master/home_assistant/install.podman.sh && bash install.sh`

Installing and running the containers with Podman doesn't require the use of sudo

### Docker
`wget -O install.sh https://raw.githubusercontent.com/rdiazlugo/home-docker/refs/heads/master/home_assistant/install.docker.sh && sudo bash install.sh`

Installing and running the containers with Docker requires the use of `sudo`. Consider that the script also installs the crontab script under the root user.

## Requirements

I usually run it in a Proxmox LXC Container with the following resources
- OS: Debian 12
- CPU: 1vCPU
- RAM: 512MB
- HDD: 4GB
