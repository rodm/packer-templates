#!/bin/bash

# Install Java
JDK_BASE_URL=${JDK_BASE_URL:-http://download.oracle.com/otn-pub/java/jdk/8u102-b14}
JDK_URL=${JDK_URL:-$JDK_BASE_URL/jdk-8u102-macosx-x64.dmg}
JDK_FILE=${JDK_URL##*/}
TMPMOUNT=`/usr/bin/mktemp -d /tmp/jdk.XXXX`

curl -s -L -b "oraclelicense=a" $JDK_URL -o /tmp/$JDK_FILE
hdiutil attach /tmp/$JDK_FILE -mountpoint $TMPMOUNT
/usr/sbin/installer -pkg $TMPMOUNT/JDK*.pkg -target /
hdiutil detach $TMPMOUNT

# Install TeamCity Build Agent
TEAMCITY_PKG_URL=${TEAMCITY_PKG_URL:-https://bintray.com/artifact/download/rodm/pkg/teamcity-agent-1.1-23.pkg}
TEAMCITY_PKG_FILE=${TEAMCITY_PKG_URL##*/}

curl -s -L $TEAMCITY_PKG_URL -o /tmp/$TEAMCITY_PKG_FILE
/usr/sbin/installer -pkg /tmp/$TEAMCITY_PKG_FILE -target /

# Configure TeamCity Build Agent
JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
sed -i .bak -e "s|^wrapper.java.command=.*$|wrapper.java.command=$JAVA_HOME/bin/java|g" \
    /etc/teamcity-agent/wrapper.conf
