#!/bin/sh
#
# Startup script for Nexus Artifact Repository Server using Apache Tomcat
#
# description: Run Nexus Artifact Repository Server
# processname: server

PRGDIR=`dirname $0`
NEXUS_HOME=`cd $PRGDIR/.. ; pwd`

if [ ! -f /etc/nexus-server.conf ]; then
    echo "No configuration file found for Nexus server"
    exit 1
fi
. /etc/nexus-server.conf

NEXUS_USER_ID=$(id -u nexus)

if [ "$(id -u)" -ne "$NEXUS_USER_ID" ]; then
    echo "Nexus should be started under the 'nexus' user"
    exit 1
fi

if [ -z $CATALINA_HOME ]; then
    echo "CATALINA_HOME not set in configuration file"
    exit 1
fi
if [ ! -f $CATALINA_HOME/bin/startup.sh ]; then
    echo "No Tomcat installation found at '$CATALINA_HOME'"
    exit 1
fi

CATALINA_BASE=$NEXUS_HOME

export JAVA_HOME CATALINA_HOME CATALINA_BASE

NEXUS_WORK=${NEXUS_WORK:-$NEXUS_HOME/sonatype-work/nexus}

[ -d $NEXUS_HOME/temp ] || mkdir $NEXUS_HOME/temp
[ -d $NEXUS_HOME/work ] || mkdir $NEXUS_HOME/work

case "$1" in
  start)
    echo "Starting Nexus Server"
    JAVA_OPTS=-Xmx256m
    JAVA_OPTS="$JAVA_OPTS -verbose:gc -Xloggc:${NEXUS_HOME}/logs/gc.log"
    JAVA_OPTS="$JAVA_OPTS -Dnexus"
    JAVA_OPTS="$JAVA_OPTS -Dnexus-work=${NEXUS_WORK}"
    JAVA_OPTS="$JAVA_OPTS -Djava.awt.headless=true"
    JAVA_OPTS="$JAVA_OPTS -Dnexus.remoteStorage.enableCircularRedirectsForHosts=maven.oracle.com"
    JAVA_OPTS="$JAVA_OPTS -Dnexus.remoteStorage.useCookiesForHosts=maven.oracle.com"
    if [ ! "$JMX_PORT" = "" ]; then
        JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote"
        JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote.port=$JMX_PORT"
        JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote.ssl=false"
        JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote.authenticate=false"
    fi
    export JAVA_OPTS
    $CATALINA_HOME/bin/startup.sh
    echo
    ;;

  stop)
    echo "Shutting down Nexus Server"
    $CATALINA_HOME/bin/shutdown.sh
    echo
    ;;

  *)
    echo "Usage: `basename $0` {start|stop}"
    exit 1
esac

exit 0
