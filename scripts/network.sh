#!/bin/sh

. /etc/lsb-release

if [ "${DISTRIB_CODENAME}" = "bionic" ]; then
    cat > /etc/netplan/01-netcfg.yaml <<EOF
network:
  version: 2
  ethernets:
    ens160:
      dhcp4: true
EOF
else
    cat > /etc/network/interfaces.d/ens160 <<EOF
auto ens160
iface ens160 inet dhcp
EOF
fi
