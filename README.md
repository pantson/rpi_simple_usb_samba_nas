# rpi_simple_usb_samba

## Auto install

ssh to your raspberry pi and run
```
wget -O - https://raw.githubusercontent.com/pantson/rpi_simple_usb_samba/main/install.sh | sudo bash
```
in /home/pi

## Scope

### Whats in scope?

This script will install samba, ntfs-3g and fuse. 

On every boot it will scan the plugged in USB drives and mount any folders that are in *shares* folder of a usb stick

Example:
```
USB1
+ shares
|    + music
|    - photos
- pictures

USB2
+ shares
     - documents
```
The above layout will create samba shares 'music','photos' and 'documents'. It will not create a share called pictures as its not in the shares folder.

These share will be set as public and readonly.

This makes it really easy for a home network as EVERYONE will have READ access to the shares.

If you are wanting authentication per user, this is not the script for you.

### Whats not in scope?

The script will not change the hostname of the raspberry pi device, nor will it set the password. To perform these actions, use raspi-config
```
sudo raspi-config
```
