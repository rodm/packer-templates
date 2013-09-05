#!/bin/sh

if [ ! "`virt-what`" = "vmware" ]; then
    exit 0
fi

if [ -f /etc/redhat-release ]; then
    yum -y install perl fuse-libs
fi

# Install the VMWare Tools from a Linux ISO.
mkdir -p /mnt/vmware
mount -o loop /tmp/linux.iso /mnt/vmware
tar xzf /mnt/vmware/VMwareTools-*.tar.gz -C /tmp
umount /mnt/vmware
rmdir /mnt/vmware
rm -f /tmp/linux.iso

/tmp/vmware-tools-distrib/vmware-install.pl -d
rm -fr /tmp/vmware-tools-distrib
