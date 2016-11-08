#!/bin/sh

# Install various packages required to run Munin
apt-get update -y
apt-get install -y -q unzip
apt-get install -y -q curl
apt-get install -y -q apache2
apt-get install -y -q munin
apt-get install -y -q avahi-daemon

# Configure Munin
sed -i -e "/^<Directory.*/,/^<\/Directory.*/ s|\(.*Order allow,deny.*\)|#\1|" /etc/munin/apache.conf
sed -i -e "/^<Directory.*/,/^<\/Directory.*/ s|\(.*Allow from.*\)|#\1|" /etc/munin/apache.conf
sed -i -e "/^<Directory.*/,/^<\/Directory.*/ s|#.*Allow from.*|&\n        Require all granted|" /etc/munin/apache.conf
sed -i -e "/^#.*simple host tree/,+3 s|\(.*\)|#\1|" /etc/munin/munin.conf
