#!/bin/sh

# Load up the release information
. /etc/lsb-release

# Vagrant specific
date > /etc/vagrant_box_build_time

# Setup sudo to allow no-password sudo
sed -i -e 's/%admin .*/%admin ALL=(ALL) NOPASSWD:ALL/' /etc/sudoers
if [ "${DISTRIB_CODENAME}" = "precise" ]; then
    sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=admin' /etc/sudoers
fi
groupadd -r admin
usermod -a -G admin vagrant

# Installing vagrant keys
mkdir /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh

# Customize the message of the day
echo 'Welcome to your Vagrant-built virtual machine.' > /etc/motd
