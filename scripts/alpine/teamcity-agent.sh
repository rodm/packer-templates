#!/bin/sh

set -eux

# Install packages required to run a TeamCity Build Agent
apk add dbus
apk add avahi
apk add unzip
apk add curl
#apk add xvfb
#apk add libxtst
#apk add libxi
#apk add libxrender
#apk add fontconfig

mkdir -p /opt

# Install Java
JDK_URL=${JDK_URL:-http://somehost/jdk-8u181-linux-x64.tar.gz}
JDK_FILE=${JDK_URL##*/}
JAVA_HOME=/opt/jdk-9
if [ ! -d $JAVA_HOME ]; then
    curl -s -L -b "oraclelicense=a" $JDK_URL -o /tmp/$JDK_FILE
    tar -xzf /tmp/$JDK_FILE -C /opt
fi

# Install and configure TeamCity Build Agent
TEAMCITY_USER=teamcity
TEAMCITY_GROUP=teamcity

addgroup teamcity
adduser -S -G $TEAMCITY_GROUP -s /bin/sh -h /opt/teamcity-agent $TEAMCITY_USER

mkdir -p /var/lib/teamcity-agent /var/log/teamcity-agent /var/run/teamcity-agent
chown -R $TEAMCITY_USER:$TEAMCITY_GROUP /var/lib/teamcity-agent /var/log/teamcity-agent
chmod u+rwx /var/lib/teamcity-agent /var/log/teamcity-agent
chown -R $TEAMCITY_USER:$TEAMCITY_GROUP /var/run/teamcity-agent
chmod -R 750 /var/run/teamcity-agent

mkdir -p /etc/teamcity-agent /usr/share/teamcity-agent
cp /tmp/teamcity-agent.init /etc/init.d/teamcity-agent
cp /tmp/agent.sh /usr/share/teamcity-agent
cp /tmp/teamcity-agent.conf /etc/teamcity-agent

chown -R $TEAMCITY_USER:$TEAMCITY_GROUP /etc/teamcity-agent
chmod +x /etc/init.d/teamcity-agent
chmod +x /usr/share/teamcity-agent/agent.sh

AGENT_URL=${AGENT_URL:-http://localhost:8111/update/buildAgent.zip}
AGENT_FILE=${AGENT_URL##*/}
curl -s -L $AGENT_URL -o /tmp/$AGENT_FILE
unzip -q /tmp/$AGENT_FILE -d /opt/teamcity-agent

# Configure TeamCity Build Agent
sed -e "s/^workDir=.*/workDir=\/var\/lib\/teamcity-agent\/work/g" \
    -e "s/^tempDir=.*/tempDir=\/var\/lib\/teamcity-agent\/temp/g" \
    -e "s/^systemDir=.*/systemDir=\/var\/lib\/teamcity-agent\/system/g" \
    -e "s/\r$//g" \
    < /opt/teamcity-agent/conf/buildAgent.dist.properties \
    > /etc/teamcity-agent/teamcity-agent.properties

sed -i -e "s|^JAVA_HOME=.*$|JAVA_HOME=$JAVA_HOME|g" /etc/teamcity-agent/teamcity-agent.conf

chown -R $TEAMCITY_USER:$TEAMCITY_GROUP /etc/teamcity-agent /opt/teamcity-agent
chmod +x /opt/teamcity-agent/bin/*.sh

rc-update add teamcity-agent default

