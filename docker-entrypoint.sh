#!/bin/bash
set -e

if [ -z $ES_HOST ] ; then
  echo "FATAL: environment variable ES_HOST missing." && exit 1
fi

if [ -z $ES_PORT ] ; then
  echo "FATAL: environment variable ES_PORT missing." && exit 1
fi

if [ -z $ES_USER ] ; then
  echo "FATAL: environment variable ES_USER missing." && exit 1
fi

if [ -z $ES_PASS ] ; then
  echo "FATAL: environment variable ES_PASS missing." && exit 1
fi

if [ -z $DELETE_UNIT ] ; then
  echo "FATAL: environment variable DELETE_UNIT missing." && exit 1
fi

if [ -z $DELETE_UNIT_COUNT ] ; then
  echo "FATAL: environment variable DELETE_UNIT_COUNT missing." && exit 1
fi

KIBANA_INDEX=${KIBANA_INDEX:-.kibana}

sed -i -e "s;^  hosts: \[ '127\.0\.0\.1' \];  hosts: [ '${ES_HOST}' ];" \
       -e "s;^  port: 9200;  port: ${ES_PORT};" \
       -e "s;^  http_auth:;  http_auth: '${ES_USER}:${ES_PASS}';" \
       -e "s;^  use_ssl: False;  use_ssl: True;" \
       /opt/curator/config/curator.yml

sed -i -e "s;^      unit: days;      unit: ${DELETE_UNIT};" \
       -e "s;^      unit_count: 30;      unit_count: ${DELETE_UNIT_COUNT};" \
       /opt/curator/config/action.yml

# Add /usr/local/bin/curator as command if needed
if [[ "$1" == -* ]]; then
  set -- /usr/local/bin/curator "$@"
fi

exec "$@"
