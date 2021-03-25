#!/bin/bash

# This software is provided 'as-is', without any express or implied
# warranty.  In no event will the authors be held liable for any damages
# arising from the use of this software.
#
# Permission is granted to anyone to use this software for any purpose,
# including commercial applications, and to alter it and redistribute it
# freely, subject to the following restrictions:
#
# 1. The origin of this software must not be misrepresented; you must not
# claim that you wrote the original software. If you use this software
# in a product, an acknowledgment in the product documentation would be
# appreciated but is not required.
# 2. Altered source versions must be plainly marked as such, and must not be
# misrepresented as being the original software.
# 3. This notice may not be removed or altered from any source distribution.

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

