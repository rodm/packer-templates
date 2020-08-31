#!/bin/sh

# Setup sudo to allow no-password sudo
if [ -f /etc/lsb-release ]; then
    cat > /etc/sudoers.d/vagrant << EOF
Defaults:vagrant !requiretty
vagrant        ALL=(ALL)       NOPASSWD: ALL
EOF
    chmod 440 /etc/sudoers.d/vagrant
fi

# Vagrant specific
date > /etc/vagrant_box_build_time

# Installing vagrant keys
mkdir /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
wget --no-check-certificate 'https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub' -O /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh

# Customize the message of the day
echo 'Welcome to your Vagrant-built virtual machine.' > /etc/motd
