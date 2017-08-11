#!/bin/sh

if [ -f /etc/redhat-release ]; then
    cat > /etc/yum.repos.d/bintray-rodm.repo <<EOF
# bintray-rodm - packages by rodm from Bintray
[bintray-rodm]
name=bintray-rodm-rpm
baseurl=https://dl.bintray.com/rodm/rpm
gpgcheck=0
enabled=1
EOF
else
    . /etc/lsb-release
    cat > /etc/apt/sources.list.d/bintray-rodm.list <<EOF
# Bintray packages
deb https://dl.bintray.com/rodm/deb $DISTRIB_CODENAME main
EOF
fi

# Install packages required to run a TeamCity Build Agent
if [ -f /etc/redhat-release ]; then
    yum install -y -q epel-release
    yum install -y -q avahi
    yum install -y -q nss-mdns
    yum install -y -q unzip
    yum install -y -q curl
    yum install -y -q xorg-x11-server-Xvfb
    yum install -y -q libXtst
    yum install -y -q libXi
    yum install -y -q libXrender
    yum install -y -q fontconfig
    yum install -y -q rpm-build
    yum install -y -q teamcity-agent
    yum clean -y all
else
    apt-get update -y
    apt-get install -y -q avahi-daemon
    apt-get install -y -q unzip
    apt-get install -y -q curl
    apt-get install -y -q xvfb
    apt-get install -y -q libxtst6
    apt-get install -y -q libxi6
    apt-get install -y -q libxrender1
    apt-get install -y -q libfontconfig1
    apt-get install --force-yes -y -q teamcity-agent
    apt-get -y clean
fi

# Configure firewall to allow TeamCity Build Agent and mDNS access
if [ -f /etc/redhat-release ]; then
    iptables -I INPUT 5 -p tcp --dport 9090 -m comment --comment "TeamCity Build Agent" -j ACCEPT
    iptables -I INPUT 6 -d 224.0.0.251/32 -p udp -m udp --dport 5353 -m comment --comment "mDNS" -j ACCEPT
    /sbin/service iptables save
fi

# Install Java
JDK_BASE_URL=${JDK_BASE_URL:-http://download.oracle.com/otn-pub/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135}
JDK_URL=${JDK_URL:-$JDK_BASE_URL/jdk-8u144-linux-x64.tar.gz}
JDK_FILE=${JDK_URL##*/}
JAVA_HOME=/opt/$(echo $JDK_FILE | sed -e 's|jdk-\([0-9]\)u\([0-9]\{1,3\}\).*|jdk1.\1.0_\2|')
mkdir -p /opt
if [ ! -d $JAVA_HOME ]; then
    curl -s -L -b "oraclelicense=a" $JDK_URL -o /tmp/$JDK_FILE
    tar -xzf /tmp/$JDK_FILE -C /opt
fi

# Configure TeamCity Build Agent
sed -i -e "s|^JAVA_HOME=.*$|JAVA_HOME=$JAVA_HOME|g" /etc/teamcity-agent/teamcity-agent.conf
