#!/bin/sh

if [ ! $PACKER_BUILDER_TYPE = vmware-iso -a ! $PACKER_BUILDER_TYPE = vmware-vmx ]; then
    exit 0
fi

if [ -f /etc/redhat-release ]; then
    yum -y install kernel-devel-`uname -r`
    yum -y install gcc make gcc-c++ zlib-devel openssl-devel readline-devel perl dkms fuse fuse-devel nfs-utils
fi

# Install the VMWare Tools from a Linux ISO.
mkdir -p /mnt/vmware
mount -o loop /tmp/linux.iso /mnt/vmware
tar xzf /mnt/vmware/VMwareTools-*.tar.gz -C /tmp
umount /mnt/vmware
rmdir /mnt/vmware
rm -f /tmp/linux.iso

# use force install option so that hgfs is installed for vagrant
/tmp/vmware-tools-distrib/vmware-install.pl --default --force-install
rm -fr /tmp/vmware-tools-distrib
