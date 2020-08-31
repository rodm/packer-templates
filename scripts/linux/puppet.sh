#!/bin/sh

if [ -f /etc/redhat-release ]; then
    # Prepare puppetlabs repo
    RELEASE=`uname -a|sed -n "s/.*el\([0-9]\).*/\1/p"`
    sudo rpm -ivh http://yum.puppetlabs.com/el/$RELEASE/products/x86_64/puppetlabs-release-$RELEASE-11.noarch.rpm

    # Install puppet and facter
    yum -y install puppet facter
else
    # Load up the release information
    . /etc/lsb-release

    # Prepare puppetlabs repo
    wget http://apt.puppetlabs.com/puppetlabs-release-${DISTRIB_CODENAME}.deb -P /tmp
    dpkg -i /tmp/puppetlabs-release-${DISTRIB_CODENAME}.deb
    apt-get -y update

    # Install puppet and facter
    apt-get install -y puppet facter
fi
