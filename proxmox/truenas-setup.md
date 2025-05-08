## Setting up TrueNAS on a Proxmox server

### Post install script
- [Post PVE Install](https://community-scripts.github.io/ProxmoxVE/scripts?id=post-pve-install)
- [Microcode](https://community-scripts.github.io/ProxmoxVE/scripts?id=microcode)
- Add Powertop (./install-latest-powertop.sh) - [Examples](https://www.reddit.com/r/Proxmox/comments/1b8s8gd/comment/m1r0r72/)
- Update the cron to run on start ([example](https://www.reddit.com/r/Proxmox/comments/1b8s8gd/comment/mbu2hc1/))
  -
-


### Adding Disks to Truenas

When TrueNAS is installed as a Guest in a Proxmox host, we need to pass the disks controllers to the guest.

1. In Proxmox terminal, list the available disks and the model and serial: `lsblk -o +MODEL,SERIAL`

2. Once you can identify the disk based on the capacity and model, we need the full disk ID `ls /dev/disk/by-id/`

3. This gives us a list of disks, we then will add these disks to the Guest machine this way `qm set {GUEST_ID} -scsi{#} /dev/disk/by-id/{DISK_ID}`

4. After you have added the SCSI to the host, copy the SERIAL and also pass it as parameter to the guest config, update the config present on `nano /etc/pve/qemu-server/{GUEST_ID}.conf` and add the serial at the end of the `scsi` line like this: `scsi1: /dev/disk/by-id/ata-ST4000NE001-2MA101_WS255XCJ,size=3907018584K,serial=WS255XCJ`, it helps prevent a warning and data loss as each disk is uniquely identifiable.

5. Save the config file and (re)start the guest machine
