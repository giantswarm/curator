#!/bin/bash
set -e

KIBANA_INDEX=${KIBANA_INDEX:-.kibana}
ES_HOST=${ES_HOST:-elasticsearch}
ES_PORT=${ES_PORT:-9200}
DELETE_UNIT=${DELETE_UNIT:-days}
DELETE_UNIT_COUNT=${DELETE_UNIT_COUNT:-14}
INDEX_NAME_PREFIX=${INDEX_NAME_PREFIX:-fluentd-}
TIMESTRING=${TIMESTRING:-%Y.%m.%d}

sed -i -e "s;^  hosts: \['127\.0\.0\.1'\];  hosts: [\"${ES_HOST}\"];" \
       -e "s;^  port: 9200;  port: ${ES_PORT};" \
       /opt/curator/config/curator.yaml

sed -i -e "s;^      unit: days;      unit: ${DELETE_UNIT};" \
       -e "s;^      unit_count: 14;      unit_count: ${DELETE_UNIT_COUNT};" \
       -e "s;^      value: fluentd-;      value: ${INDEX_NAME_PREFIX};" \
       -e "s;^      timestring: '%Y.%m.%d';      timestring: \"${TIMESTRING}\";" \
       /opt/curator/config/action.yaml

# Add /usr/local/bin/curator as command if needed
if [[ "$1" == -* ]]; then
  set -- /usr/local/bin/curator "$@"
fi

exec "$@"
