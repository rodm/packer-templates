#!/bin/sh -ex

apk add openssl
apk add sudo

sed -i \
    -e 's/^#PermitRootLogin .*/PermitRootLogin yes/' \
    -e 's/^#PubkeyAuthentication yes/PubkeyAuthentication yes/' \
    -e 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' \
    -e 's/^#UseDNS no/UseDNS no/' \
    /etc/ssh/sshd_config

adduser -D builder
echo "builder:builder" | chpasswd builder

echo "builder ALL=(ALL) ALL" >> /etc/sudoers

reboot
