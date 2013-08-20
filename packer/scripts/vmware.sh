#!/bin/sh

if [ ! "`virt-what`" = "vmware" ]; then
    exit 0
fi

# Install the VMWare Tools from a Linux ISO.
mkdir -p /mnt/vmware
mount -o loop /home/vagrant/linux.iso /mnt/vmware
tar xzf /mnt/vmware/VMwareTools-*.tar.gz -C /tmp
umount /mnt/vmware
rmdir /mnt/vmware
rm -f /home/vagrant/linux.iso

/tmp/vmware-tools-distrib/vmware-install.pl -d
rm -fr /tmp/vmware-tools-distrib
