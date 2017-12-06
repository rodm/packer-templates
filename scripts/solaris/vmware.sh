#!/bin/sh

if [ $PACKER_BUILDER_TYPE = 'vmware-iso' ]; then

    # Install the VMWare Tools from a Solaris ISO.
    DEV=`/usr/sbin/lofiadm -a /tmp/solaris.iso`
    mkdir -p /mnt/vmware
    /usr/sbin/mount -F hsfs -o ro $DEV /mnt/vmware
    cd /tmp
    gunzip -c /mnt/vmware/vmware-solaris-tools.tar.gz | tar -xf -
    /usr/sbin/umount /mnt/vmware
    /usr/sbin/lofiadm -d $DEV
    rmdir /mnt/vmware
    rm -f solaris.iso

    /tmp/vmware-tools-distrib/vmware-install.pl --default
    rm -rf /tmp/vmware-tools-distrib
fi
