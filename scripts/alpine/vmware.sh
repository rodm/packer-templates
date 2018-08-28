#!/bin/sh

set -eux

apk --update add open-vm-tools
rm -rf /var/cache/apk/*
rc-update add open-vm-tools default
service open-vm-tools start
vmware-toolbox-cmd timesync enable
