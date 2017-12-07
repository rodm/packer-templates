#!/bin/sh

if [ -f /etc/redhat-release ]; then
    yum -y -q clean all
#    yum -y update
else
    apt-get -y update
    apt-get -y autoclean
    apt-get -y clean
fi
