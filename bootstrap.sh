#!/bin/bash
: ${ES_DATA_PATH:="/var/lib/elasticsearch"}
: ${ES_WORK_PATH:="/tmp/elasticsearch"}
: ${ES_CLUSTER_NAME:="logstash-es"}
: ${ES_UNICAST_HOSTS:="localhost"}
: ${ES_MULTICAST_ENABLED:=false}
: ${ES_NODE_NAME:="baywatch-node-1"}

cat >> /etc/default/elasticsearch <<EOF

# Data path (intended to be used as a volume)
export ES_DATA_PATH="$ES_DATA_PATH"

# Work dir path (intended to be used as a volume)
export ES_WORK_PATH="$ES_WORK_PATH"

# The name of the cluster
export ES_CLUSTER_NAME="$ES_CLUSTER_NAME"

# For cluster discovery
export ES_UNICAST_HOSTS="$ES_UNICAST_HOSTS"

# Enable/disable multicast
export ES_MULTICAST_ENABLED="$ES_MULTICAST_ENABLED"

# Default node name
export ES_NODE_NAME="$ES_NODE_NAME"

EOF

echo "Elasticsearch data path: $ES_DATA_PATH"
service elasticsearch start
service nginx start

# keep the container alive in the background or in forground
if [[ $1 == "-d" ]]; then
  echo "ES/LS/NGINX container running ..."
  while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
  echo "Bash ..."
  /bin/bash
fi
