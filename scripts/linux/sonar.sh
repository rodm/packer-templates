#!/bin/sh

#set -e

JDK_URL=${JDK_URL:-https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz}
JDK_FILE=${JDK_URL##*/}
JAVA_HOME=/opt/$(echo $JDK_FILE | sed -e 's|.*jdk-\([0-9][0-9]\.[0-9]\.[0-9]\).*|jdk-\1|')

SONAR_DB_NAME=sonar
SONAR_DB_USER=sonar
SONAR_DB_PASS=sonar

SONAR_URL=${SONAR_URL:-https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-7.9.zip}
SONAR_FILE=${SONAR_URL##*/}
SONAR_DIR=/opt/${SONAR_FILE%.*}

SONAR_USER=sonar
SONAR_GROUP=sonar

# Install various packages required to install, configure and run SonarQube
apt-get update -y
apt-get install -y -q unzip
apt-get install -y -q curl

# Install Postgres
apt-get install -y postgresql
apt-get clean

# Create database
cat > /tmp/database-setup.sql <<EOF
CREATE USER $SONAR_DB_USER WITH ENCRYPTED PASSWORD '$SONAR_DB_PASS';
CREATE DATABASE $SONAR_DB_NAME WITH OWNER $SONAR_DB_USER ENCODING 'UTF8';
EOF
su - postgres -c "psql < /tmp/database-setup.sql"

# Install Java
mkdir -p /opt
if [ ! -d $JAVA_HOME ]; then
    if [ ! -f /tmp/$JDK_FILE ]; then
        curl -s -L -b "oraclelicense=a" $JDK_URL -o /tmp/$JDK_FILE
    fi
    tar -xzf /tmp/$JDK_FILE -C /opt
fi

# Setup a user to run the SonarQube server
/usr/sbin/groupadd -r $SONAR_GROUP 2>/dev/null
/usr/sbin/useradd -c $SONAR_USER -r -s /bin/bash -d $SONAR_DIR -g $SONAR_GROUP $SONAR_USER 2>/dev/null

# Install SonarQube zip file
if [ ! -d $SONAR_DIR ]; then
    if [ ! -f /tmp/$SONAR_FILE ]; then
        wget -q --no-proxy $SONAR_URL -P /tmp
    fi
    unzip -q /tmp/$SONAR_FILE -d /opt
fi

chown -R $SONAR_USER:$SONAR_GROUP $SONAR_DIR

# Configure SonarQube to use Postgres
sed -i -e "s|^#\(sonar.jdbc.username=\).*|\1$SONAR_DB_NAME|" \
       -e "s|^#\(sonar.jdbc.password=\).*|\1$SONAR_DB_PASS|" \
       -e "s|^#sonar.jdbc.url=jdbc:postgres.*|&\nsonar.jdbc.url=jdbc:postgresql://localhost/sonar|" \
       $SONAR_DIR/conf/sonar.properties

# Configure SonarQube to use installed Java
sed -i -e "s|^\(wrapper.java.command=\).*|\1$JAVA_HOME/bin/java|" $SONAR_DIR/conf/wrapper.conf

# Configure SonarQube to run as user sonar
sed -i -e "s|^#RUN_AS_USER=.*|&\nRUN_AS_USER=$SONAR_USER|" $SONAR_DIR/bin/linux-x86-64/sonar.sh

# Configure Linux to run SonarQube
cp /tmp/limits-sonarqube.conf /etc/security/limits.d/99-sonarqube.conf
cp /tmp/sysctl-sonarqube.conf /etc/sysctl.d/99-sonarqube.conf

# Install init script to start SonarQube on server boot
ln -sf $SONAR_DIR/bin/linux-x86-64/sonar.sh /usr/bin/sonar
if [ ! -f /etc/init.d/sonar ]; then
    cp /tmp/sonar /etc/init.d/sonar
    chmod 755 /etc/init.d/sonar
    update-rc.d sonar defaults
fi
/etc/init.d/sonar start
