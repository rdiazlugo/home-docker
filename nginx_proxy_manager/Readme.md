# Nginx Proxy Manager

Install by running this command in a terminal

`wget --no-cache https://raw.githubusercontent.com/rdiazlugo/home-docker/refs/heads/master/nginx_proxy_manager/install.sh && bash install.sh`

## Requirements

I usually run it in a Proxmox LXC Container with the following resources
- OS: Debian 12
- CPU: 1vCPU with a CPU limit of 0.5 (50% time)
- RAM: 128MB
- HDD: 3GB
