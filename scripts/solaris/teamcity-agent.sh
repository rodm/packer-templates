#!/bin/sh

# Install Java
JDK_BASE_URL=${JDK_BASE_URL:-http://download.oracle.com/otn-pub/java/jdk/8u152-b16/aa0333dd3019491ca4f6ddbe78cdb6d0}
JDK_URL=${JDK_URL:-$JDK_BASE_URL/jdk-8u152-solaris-x64.tar.gz}
JDK_FILE=${JDK_URL##*/}
JAVA_HOME=/opt/$(echo $JDK_FILE | sed -e 's|jdk-\([0-9]\)u\([0-9]\{1,3\}\).*|jdk1.\1.0_\2|')
mkdir -p /opt
if [ ! -d $JAVA_HOME ]; then
    curl -s -L -b "oraclelicense=a" $JDK_URL -o /tmp/$JDK_FILE
    /usr/bin/gtar -xzf /tmp/$JDK_FILE -C /opt
fi

# Install TeamCity Build Agent
TEAMCITY_PKG_URL=${TEAMCITY_PKG_URL:-https://bintray.com/artifact/download/rodm/pkg/teamcity-agent-1.2-26.p5p}
TEAMCITY_PKG_FILE=${TEAMCITY_PKG_URL##*/}

curl -s -L $TEAMCITY_PKG_URL -o /tmp/$TEAMCITY_PKG_FILE
pkg install -g /tmp/$TEAMCITY_PKG_FILE pkg:/teamcity-agent

# Configure TeamCity Build Agent
/usr/bin/gsed -i -e "s|^JAVA_HOME=.*$|JAVA_HOME=$JAVA_HOME|g" /etc/teamcity-agent/teamcity-agent.conf
