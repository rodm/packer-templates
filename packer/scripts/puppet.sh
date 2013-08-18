#!/bin/sh

if [ -f /etc/redhat-release ]; then
    # Prepare puppetlabs repo
    sudo rpm -ivh http://yum.puppetlabs.com/el/6/products/i386/puppetlabs-release-6-7.noarch.rpm

    # Install puppet and facter
    yum -y install puppet facter
else
    # Load up the release information
    . /etc/lsb-release

    # Prepare puppetlabs repo
    wget http://apt.puppetlabs.com/puppetlabs-release-${DISTRIB_CODENAME}.deb
    dpkg -i puppetlabs-release-${DISTRIB_CODENAME}.deb
    apt-get -y update

    # Install puppet and facter
    apt-get install -y puppet facter
fi
