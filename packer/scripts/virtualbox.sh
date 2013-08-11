#!/bin/sh

# ensure the correct kernel headers are installed
apt-get -y install linux-headers-$(uname -r)
apt-get -y install build-essential
apt-get -y install dkms

mkdir -p /mnt/virtualbox
mount -o loop /home/vagrant/VBoxGuest*.iso /mnt/virtualbox
sh /mnt/virtualbox/VBoxLinuxAdditions.run
umount /mnt/virtualbox
rm -rf /home/vagrant/VBoxGuest*.iso
