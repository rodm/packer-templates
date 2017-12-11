#!/bin/sh

# Vagrant specific
date > /etc/vagrant_box_build_time

# Installing vagrant keys
mkdir /export/home/vagrant/.ssh
chmod 700 /export/home/vagrant/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O /export/home/vagrant/.ssh/authorized_keys
chmod 600 /export/home/vagrant/.ssh/authorized_keys
chown -R vagrant /export/home/vagrant/.ssh

# Customize the message of the day
echo 'Welcome to your Vagrant-built virtual machine.' > /etc/motd
