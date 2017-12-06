#!/bin/sh

# Clear wtmp
cat /dev/null > /var/adm/wtmpx

# Zero out the free space to save space in the final image:
dd if=/dev/zero of=/EMPTY bs=1024
rm -f /EMPTY

sleep 5
