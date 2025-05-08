# Proxmox Server Setup Instructions

## Post Install Script
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/tools/pve/post-pve-install.sh)"
```

## Set CPU Governor and Update after each restart
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/tools/pve/scaling-governor.sh)"
```

## Install Processor Microcode
*Note: Not recommended as it may cause processor to stick at C3_ACPI mode* in some cases
```bash
# bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/tools/pve/microcode.sh)"
```

## Enable ASPM on the r8169 Ethernet driver for PCI bus 03:00.0
Add the following commands to your crontab (using `crontab -e`) to run at reboot:
```bash
@reboot (sleep 10 && /usr/sbin/powertop --auto-tune)
@reboot (sleep 15 && echo "powersave" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor)
@reboot (sleep 1 && echo 1 | tee /sys/bus/pci/drivers/r8169/0000:03:00.0/link/l1_2_aspm)
```

## ASPM Debug and Configuration
1. Modify the Grub Configuration:
   ```bash
   nano /etc/default/grub
   ```
2. Add `pcie_aspm=force` to the `GRUB_CMDLINE_LINUX_DEFAULT` line.
3. Update Grub:
   ```bash
   update-grub
   ```
4. Enable Wakeup on Ethernet Interface:
   ```bash
   echo 'enabled' > '/sys/class/net/enp3s0/device/power/wakeup'
   ```

## Utilities
- **List all PCI devices:**
  ```bash
  lspci -vv
  ```
- **Get available CPU governors:**
  ```bash
  cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
  ```
- **Get NVMe drive information:**
  ```bash
  apt install -y nvme-cli
  smartctl -x /dev/nvme0n1
  nvme get-feature /dev/nvme0n1
  ```
- **Get Ethernet interface info:**
  ```bash
  apt install -y ethtool
  ethtool -i enp3s0
  ```
