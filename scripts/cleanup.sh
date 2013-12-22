#!/bin/sh

# Clean up unneeded packages.
if [ -f /etc/redhat-release ]; then
    yum -y remove gcc-c++ zlib-devel openssl-devel readline-devel dkms nfs-utils
    yum -y clean all
else
    apt-get -y remove build-essential
    apt-get -y remove dkms

    apt-get -y autoremove
    apt-get -y clean
fi

# Make sure Udev doesn't block our network
rm -f /etc/udev/rules.d/70-persistent-net.rules
if [ -f /etc/redhat-release ]; then
    sed -i -e '/HWADDR/d' /etc/sysconfig/network-scripts/ifcfg-eth0
fi

# Clean up tmp
rm -rf /tmp/*