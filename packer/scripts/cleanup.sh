#!/bin/sh

# Clean up unneeded packages.
if [ -f /etc/redhat-release ]; then
    yum -y remove kernel-devel-`uname -r`
    yum -y remove gcc make gcc-c++ zlib-devel openssl-devel readline-devel sqlite-devel perl dkms nfs-utils
    #yum -y erase gtk2 libX11 hicolor-icon-theme avahi freetype bitstream-vera-fonts
    yum -y clean all
else
    apt-get -y remove build-essential
    apt-get -y remove dkms

    apt-get -y autoremove
    apt-get -y clean
fi