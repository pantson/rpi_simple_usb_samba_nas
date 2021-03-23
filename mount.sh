#!/bin/bash
# Basic range in for loop

SAMBA=/etc/samba/smb.conf
cp /etc/samba/smb.conf.orig $SAMBA

for value in {1..9}
do
DIR=/dev/sda$value
if [ -b "$DIR" ]; then
    echo "$DIR exists."
    USB=/media/usb$value
    if ! [ -d "$USB" ]; then
        mkdir $USB
    fi
        mount $DIR $USB
    if [ -d "$USB/shares" ]; then
        echo "shares found"
        SHARE=music
        echo [$SHARE]>>$SAMBA
        echo path= $USB/shares/$SHARE>>$SAMBA
        echo writable = no>>$SAMBA
        echo public = yes>>$SAMBA
        echo create mask=0777>>$SAMBA
        echo directory mask=0777>>$SAMBA
    fi
fi
done
service smbd restart
