#!/bin/sh

JDK_BASE_URL=${JDK_BASE_URL:-http://download.oracle.com/otn-pub/java/jdk/8u112-b15}
JDK_URL=${JDK_URL:-$JDK_BASE_URL/jdk-8u112-linux-x64.tar.gz}
JDK_FILE=${JDK_URL##*/}
JAVA_HOME=/opt/$(echo $JDK_FILE | sed -e 's|jdk-\([0-9]\)u\([0-9]\{1,3\}\).*|jdk1.\1.0_\2|')

TOMCAT_VERS=7.0.72
TOMCAT_URL=http://search.maven.org/remotecontent?filepath=org/apache/tomcat/tomcat/${TOMCAT_VERS}/tomcat-${TOMCAT_VERS}.zip
TOMCAT=apache-tomcat-${TOMCAT_VERS}
TOMCAT_DIR=/opt/$TOMCAT

NEXUS_DIR=/opt/nexus
NEXUS_URL=${NEXUS_URL:-http://www.sonatype.org/downloads/nexus-latest.war}
NEXUS_USER=nexus
NEXUS_GROUP=nexus

# Install various packages required to run Nexus
apt-get update -y
apt-get install -y -q unzip
apt-get install -y -q curl
apt-get install -y -q apache2
apt-get install -y -q avahi-daemon

# Download and install Java
mkdir -p /opt
curl -s -L -b "oraclelicense=a" $JDK_URL -o /tmp/$JDK_FILE
tar -xzf /tmp/$JDK_FILE -C /opt

# Download and install Tomcat
curl -s -L $TOMCAT_URL -o /tmp/$TOMCAT.zip
unzip -q /tmp/$TOMCAT.zip -d /opt
chmod +x $TOMCAT_DIR/bin/*.sh

# Copy start/stop scripts and Tomcat configuration files
mkdir -p $NEXUS_DIR/bin
mkdir -p $NEXUS_DIR/conf
mkdir -p $NEXUS_DIR/logs
mkdir -p $NEXUS_DIR/webapps/ROOT
cp $TOMCAT_DIR/conf/* $NEXUS_DIR/conf
cp /tmp/nexus-server /etc/init.d
cp /tmp/server.sh $NEXUS_DIR/bin
curl -s -L $NEXUS_URL -o /tmp/nexus.war
unzip -q /tmp/nexus.war -d $NEXUS_DIR/webapps/ROOT
chmod +x /etc/init.d/nexus-server
chmod +x $NEXUS_DIR/bin/server.sh
chown -R $NEXUS_USER:$NEXUS_GROUP $NEXUS_DIR

# Configure Nexus
cat > /etc/nexus-server.conf <<EOF
JAVA_HOME=$JAVA_HOME
CATALINA_HOME=$TOMCAT_DIR
EOF

update-rc.d nexus-server defaults
