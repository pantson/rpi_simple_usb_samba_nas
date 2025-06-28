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
apt update
apt install samba ntfs-3g fuse3 -y -qq

# place line in crontab to call this bash script on startup
# crontab -e
# @reboot /home/pi/mount_and_share_uxb.sh

SAMBA=/etc/samba/smb.conf
LNKDIR=/opt/links
rm -rf $LNKDIR
mkdir $LNKDIR

# make backup of samba config
if ! [ -f "$SAMBA.orig" ]; then
    cp $SAMBA $SAMBA.orig
fi

# restore samba config
cp $SAMBA.orig $SAMBA

for drive in {a..z}; do
    DIR=/dev/sd${drive}1
    if [ -b "$DIR" ]; then
        echo Mounting $DIR
        USB=/media/usb$drive
        if ! [ -d "$USB" ]; then
            mkdir $USB
        fi
        mount $DIR $USB
        if [ -d "$USB/shares" ]; then
           for dir in $(ls "$USB/shares"); do
                SHARE=$(basename $dir)
                NEWLNKDIR=$LNKDIR/$SHARE
                if [ ! -d "$NEWLNKDIR" ]; then
                    mkdir $NEWLNKDIR

                    echo Sharing $SHARE
                    echo [$SHARE]>>$SAMBA
                    echo path= $LNKDIR/$SHARE>>$SAMBA
                    echo writable = no>>$SAMBA
                    echo public = yes>>$SAMBA
                    echo create mask=0777>>$SAMBA
                    echo directory mask=0777>>$SAMBA
                    echo follow symlinks = yes>>$SAMBA
                    echo wide links = yes>>$SAMBA
                fi

                for file in $USB/shares/$SHARE/*; do
                    g=${file##*/}
                    ln -s "$file" "$NEWLNKDIR/$g"
                done
            done
        fi
    fi
done

echo [global]>>$SAMBA
echo allow insecure wide links = yes>>$SAMBA

service smbd restart
