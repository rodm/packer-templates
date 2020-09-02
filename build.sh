#!/bin/bash

if [ $# = 0 ]; then
    echo "usage: $0 template-name builder"
    exit 1
fi

TEMPLATE=$1
BUILDER=$2

BUILD_DIR=`pwd`
LOGS_DIR=$BUILD_DIR/logs
LOG_FILE=$LOGS_DIR/$TEMPLATE-$BUILDER.log

mkdir -p $LOGS_DIR

# check template exists
if [ ! -f $TEMPLATE.json -a ! -f templates/$TEMPLATE.json ]; then
    echo "template $TEMPLATE does not exist"
    exit 1
fi

if [ -f packer.conf ]; then
    source ./packer.conf
fi

if [ -f $TEMPLATE.json ]; then
    TEMPLATE_FILE=$BUILD_DIR/$TEMPLATE.json
elif [ -f templates/$TEMPLATE.json ]; then
    TEMPLATE_FILE=$BUILD_DIR/templates/$TEMPLATE.json
fi

if [ -f vars/$TEMPLATE-vars.json ]; then
    VAR_OPTS="-var-file=$BUILD_DIR/vars/$TEMPLATE-vars.json"
fi

time PACKER_LOG=1 $PACKER_HOME/packer build --force --only=$BUILDER $VAR_OPTS $TEMPLATE_FILE 2>&1 | tee $LOG_FILE
