#!/bin/bash

OSX_VERS=$(sw_vers -productVersion | awk -F "." '{print $2}')

# Turn off hibernation and get rid of the sleepimage
pmset hibernatemode 0
rm -f /var/vm/sleepimage

# Stop the pager process and drop swap files. These will be re-created on boot.
# Starting with El Capitan we can only stop the dynamic pager if SIP is disabled.
if [ "$OSX_VERS" -lt 11 ] || $(csrutil status | grep -q disabled); then
    launchctl unload /System/Library/LaunchDaemons/com.apple.dynamic_pager.plist
    sleep 5
fi
rm -rf /private/var/vm/swap*

# Zero out the free space to save space in the final image:
dd if=/dev/zero of=/EMPTY bs=1m
rm -vf /EMPTY

sleep 5
