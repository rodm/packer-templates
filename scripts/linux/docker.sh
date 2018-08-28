#!/bin/sh

set -eux

# Install steps taken from https://docs.docker.com/install/
if [ -f /etc/redhat-release ]; then
    yum install -y yum-utils
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    echo "GPG fingerprint: 060A 61C5 1B55 8A7F 742B 77AA C52F EB6B 621E 9F35"
    yum install -y docker-ce
#    yum install -y docker-compose
    systemctl enable docker
    systemctl start docker
else
    apt-get update
    apt-get install -y apt-transport-https
    apt-get install -y ca-certificates
    apt-get install -y software-properties-common
    apt-get install -y software-properties-common
    apt-get install -y curl
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

    apt-get update
    apt-get install -y docker-ce
    apt-get install -y docker-compose
fi
