#!/bin/bash
wget https://raw.githubusercontent.com/pantson/rpi_simple_usb_samba/main/mount_and_share_uxb.sh
chmod +x file
sudo awk '/exit 0/ { print "sudo bash /home/pi/mount_and_share_uxb.sh"}1' /etc/rc.local > /tmp/rc.local
sudo mv /tmp/rc.local /etc/rc.local
