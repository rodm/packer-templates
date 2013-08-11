#!/bin/sh

# Load up the release information
. /etc/lsb-release

# Prepare puppetlabs repo
wget http://apt.puppetlabs.com/puppetlabs-release-${DISTRIB_CODENAME}.deb
dpkg -i puppetlabs-release-${DISTRIB_CODENAME}.deb
apt-get -y update

# Install puppet and facter
apt-get install -y puppet facter
