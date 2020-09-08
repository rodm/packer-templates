#!/bin/bash

set -eux

if [ ! -z "$(ls -A /tmp/ssh)" ]; then
    mkdir -p /home/builder/.ssh
    chmod 700 /home/builder/.ssh
    touch /home/builder/.ssh/authorized_keys
    chmod 600 /home/builder/.ssh/authorized_keys
    chown -R builder:builder /home/builder/.ssh
    cat /tmp/ssh/*.pub >> /home/builder/.ssh/authorized_keys
fi
