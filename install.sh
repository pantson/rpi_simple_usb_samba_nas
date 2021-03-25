#!/bin/bash

# download file
wget -O mount_and_share_uxb.sh https://raw.githubusercontent.com/pantson/rpi_simple_usb_samba/main/mount_and_share_uxb.sh

# execute rights
chmod +x mount_and_share_uxb.sh

# edit /etc/rc.local
grep -qxF 'sudo bash /home/pi/mount_and_share_uxb.sh' /etc/rc.local || sudo awk '/^exit 0/ { print "sudo bash /home/pi/mount_and_share_uxb.sh"}1' /etc/rc.local > /tmp/rc.local
if [ -f "/tmp/rc.local" ]; then
  mv /tmp/rc.local /etc/rc.local
fi

# reboot
echo Rebooting...
shutdown -r now
