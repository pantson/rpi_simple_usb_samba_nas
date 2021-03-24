#!/bin/bash

# automounts any usb drive in raspberry pi
# creates public readonly samba share for each folder on each usn stick under /[usb]/shares/
# eg /usb1/shares/music is shared as music

# requires samba installing
# sudo apt-get install samba

# place line in /etc/rc.local to call this bash script on startup
# eg sudo bash /home/pi/mount_and_share_uxb.sh

SAMBA=/etc/samba/smb.conf

# make backup of samba config
if ! [ -f "$SAMBA" ]; then
    cp $SAMBA /etc/samba/smb.conf.orig
fi

# restore samba config
cp /etc/samba/smb.conf.orig $SAMBA

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
       for dir in "$USB/shares/*"; do
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
