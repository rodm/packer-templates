#!/bin/sh


if [ $PACKER_BUILDER_TYPE = 'virtualbox-iso' ]; then

    # Install the VirtualBox Guest Additions
    DEV=`/usr/sbin/lofiadm -a /tmp/VBoxGuestAdditions.iso`
    mkdir -p /mnt/virtualbox
    /usr/sbin/mount -F hsfs -o ro $DEV /mnt/virtualbox

    yes | /usr/sbin/pkgadd -d /mnt/virtualbox/VBoxSolarisAdditions.pkg SUNWvboxguest

    /usr/sbin/umount /mnt/virtualbox
    /usr/sbin/lofiadm -d $DEV
    rmdir /mnt/virtualbox
    rm -f /tmp/VBoxGuestAdditions.iso
fi
