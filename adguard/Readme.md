# AdGuard

Install by running this command in a terminal

`wget https://raw.githubusercontent.com/rdiazlugo/home-docker/refs/heads/master/adguard/install.sh && bash install.sh`

## Requirements

I usually run it in a Proxmox LXC Container with the following resources
- OS: Debian 12
- CPU: 1vCPU
- RAM: 128MB
- HDD: 2GB

## References

- https://medium.com/@life-is-short-so-enjoy-it/homelab-adguard-setup-unbound-as-iterative-dns-6048d5072276
- https://www.baeldung.com/linux/run-script-on-startup
- Install script isnpired from Community Script install scripts - [source](https://community-scripts.github.io/ProxmoxVE/scripts?id=adguard)
