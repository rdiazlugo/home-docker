apt install libpci-dev libnl-3-dev libnl-genl-3-dev gettext \
  libgettextpo-dev autopoint gettext libncurses5-dev libncursesw5-dev libtool-bin \
  dh-autoreconf autoconf-archive pkg-config git autoconf automake build-essential curl

curl -L https://github.com/fenrus75/powertop/releases/download/v2.15/powertop.tar.gz | tar -xz
cd powertop
./autogen.sh
./configure
make install

# Run powertop on restart crontab
echo "@reboot (sleep 60 && /usr/sbin/powertop --auto-tune)" | crontab -
# Enable ASPM on the r8169 driver for the Ethernet interface on PCI bus 03:00.0
echo "@reboot echo 1 | tee /sys/bus/pci/drivers/r8169/0000\:03\:00.0/link/l1_2_aspm" | crontab -
# Enable ASPM on the r8169 driver for the Ethernet interface on PCI bus 03:00.0
echo "@reboot echo 'enabled' > '/sys/class/net/enp3s0/device/power/wakeup'" | crontab -
