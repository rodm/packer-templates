#!/bin/sh

# Clean up unneeded packages.
if [ -f /etc/redhat-release ]; then
    yum -y remove gcc make perl elfutils-libelf-devel dkms
    yum -y remove zlib-devel openssl-devel readline-devel fuse-devel nfs-utils
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
    for ndev in `ls -1 /etc/sysconfig/network-scripts/ifcfg-*`; do
        if [ "`basename $ndev`" != "ifcfg-lo" ]; then
            sed -i '/^HWADDR/d' "$ndev";
            sed -i '/^UUID/d' "$ndev";
        fi
    done
fi

# Clean up tmp
rm -rf /tmp/*
