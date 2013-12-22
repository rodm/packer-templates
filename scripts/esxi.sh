#!/bin/sh

esxcli system settings advanced set -o /Net/FollowHardwareMac -i 1

esxcli software vib install -v http://download3.vmware.com/software/vmw-tools/esxi_tools_for_guests/esx-tools-for-esxi-9.7.0-0.0.00000.i386.vib -f
