#!/bin/sh
export OPENNMS_HOME=/home/jesse/git/opennms/target/opennms
$OPENNMS_HOME/bin/send-event.pl uei.opennms.org/nodes/nodeLostService \
  -n 1 \
  -s "$1" \
  -p 'eventReason manual' \
  -i '127.0.0.1'
