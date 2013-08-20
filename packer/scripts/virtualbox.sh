#!/bin/sh

if [ ! "`virt-what`" = "virtualbox" ]; then
    exit 0
fi

if [ -f /etc/redhat-release ]; then
    yum -y install kernel-devel-`uname -r`
    yum -y install gcc make gcc-c++ zlib-devel openssl-devel readline-devel sqlite-devel perl wget dkms nfs-utils
else
    # ensure the correct kernel headers are installed
    apt-get -y install linux-headers-$(uname -r)
    apt-get -y install build-essential
    apt-get -y install dkms
fi

mkdir -p /mnt/virtualbox
mount -o loop /home/vagrant/VBoxGuest*.iso /mnt/virtualbox
sh /mnt/virtualbox/VBoxLinuxAdditions.run
umount /mnt/virtualbox
rm -f /home/vagrant/VBoxGuest*.iso
