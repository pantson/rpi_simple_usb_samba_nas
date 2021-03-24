#!/bin/bash

# automounts any usb drive in raspberry pi
# creates public readonly samba share for each folder on each usn stick under /[usb]/shares/
# eg /usb1/shares/music is shared as music

# requires samba installing
echo "samba-common samba-common/workgroup string  WORKGROUP" | sudo debconf-set-selections
echo "samba-common samba-common/dhcp boolean false" | sudo debconf-set-selections
echo "samba-common samba-common/do_debconf boolean true" | sudo debconf-set-selections
apt-get install samba ntfs-3g fuse -y -qq

# place line in /etc/rc.local to call this bash script on startup
# eg sudo bash /home/pi/mount_and_share_uxb.sh

SAMBA=/etc/samba/smb.conf

# make backup of samba config
if ! [ -f "$SAMBA.orig" ]; then
    cp $SAMBA $SAMBA.orig
fi

# restore samba config
cp $SAMBA.orig $SAMBA

for value in {1..9}
do
DIR=/dev/sda$value
if [ -b "$DIR" ]; then
    echo Mounting $DIR
    USB=/media/usb$value
    if ! [ -d "$USB" ]; then
        mkdir $USB
    fi
        mount $DIR $USB
    if [ -d "$USB/shares" ]; then
       for dir in $(ls "$USB/shares"); do
            SHARE=$(basename $dir)
            echo Sharing $SHARE
            echo [$SHARE]>>$SAMBA
            echo path= $USB/shares/$SHARE>>$SAMBA
            echo writable = no>>$SAMBA
            echo public = yes>>$SAMBA
            echo create mask=0777>>$SAMBA
            echo directory mask=0777>>$SAMBA
        done
    fi
fi
done
service smbd restart

