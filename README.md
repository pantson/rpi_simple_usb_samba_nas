# rpi_simple_usb_samba_nas

This repo installs a simple samba nas on your Raspberry Pi.

Each share is mounted from the usb storage on the Pi and is mounted readonly for everyone.

This is a quick and convinient way to mount readonly shares on your home network for all to see.

## USB format

Format your USB devices and add a folder called *shares*. Inside shares, you can add your folders that you want sharing on your network.

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

## Installation

Use Raspberry Pi Imager to install the Raspberry Pi Lite OS on an SD card. A small 1GB SD card is ideal, but you can use anything above this.

Copy 2 files onto the boot volume
+ ssh  (to enable ssh on boot)
+ wpa   (to auto join your wifi network. More info here  )

Place the SD card in your Pi and power on. After a few mins, you should be able to ssh to the new device (default hostname is raspberrypi).
```
default user is pi
default pwd is raspberry
```

Run the following in /home/pi

```
wget -O - https://raw.githubusercontent.com/pantson/rpi_simple_usb_samba/main/install.sh | sudo bash
```

This will install and setup the shares.

It is recommended that you change your default user and password and also the hostname of the device.
Run raspi-config to do this
```
sudo raspi-config
```

## Scope

### Whats in scope?

This script will install samba, ntfs-3g and fuse. 

On every boot it will scan the plugged in USB drives and mount any folders that are in *shares* folder of a usb stick

These share will be set as public and readonly.

This makes it really easy for a home network as EVERYONE will have READ access to the shares.

If you are wanting authentication per user, this is not the script for you.

### Whats not in scope?

The script will not change the hostname of the raspberry pi device, nor will it set the password. To perform these actions, use raspi-config
```
sudo raspi-config
```
