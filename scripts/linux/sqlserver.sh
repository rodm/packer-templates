#!/bin/sh

apt-get update -y
apt-get install -y -q avahi-daemon
apt-get install -y -q unzip
apt-get install -y -q curl
apt-get install -y -q software-properties-common

# Add Microsoft repositories
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
add-apt-repository "$(curl https://packages.microsoft.com/config/ubuntu/16.04/mssql-server-2017.list)"
add-apt-repository "$(curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list)"

apt-get update -y

# Install SQL Server
apt-get install -y mssql-server

# Configure SQL Server
MSSQL_SA_PASSWORD=$MSSQL_SA_PASSWORD \
    MSSQL_PID=$MSSQL_PID \
    /opt/mssql/bin/mssql-conf -n setup accept-eula

# Install developer tools
ACCEPT_EULA=Y apt-get install -y mssql-tools unixodbc-dev

# Install SQL Server Agent
apt-get install -y mssql-server-agent

# Enable SQL Server
systemctl enable mssql-server
