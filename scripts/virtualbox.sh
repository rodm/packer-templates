#!/bin/sh

if [ ! $PACKER_BUILDER_TYPE = virtualbox-iso -a ! $PACKER_BUILDER_TYPE = virtualbox-ovf ]; then
    exit 0
fi

if [ -f /etc/redhat-release ]; then
    yum -y install kernel-devel-`uname -r`
    yum -y install gcc make gcc-c++ zlib-devel openssl-devel readline-devel perl dkms nfs-utils
else
    # ensure the correct kernel headers are installed
    apt-get -y install linux-headers-$(uname -r)
    apt-get -y install build-essential
    apt-get -y install dkms
fi

mkdir -p /mnt/virtualbox
mount -o loop /tmp/VBoxGuest*.iso /mnt/virtualbox
sh /mnt/virtualbox/VBoxLinuxAdditions.run
umount /mnt/virtualbox
rm -f /tmp/VBoxGuest*.iso
