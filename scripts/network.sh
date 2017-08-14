#!/bin/sh

cat > /etc/network/interfaces.d/ens160 <<EOF
auto ens160
iface ens160 inet dhcp
EOF
