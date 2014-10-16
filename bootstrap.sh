#!/bin/bash
: ${ES_DATA_PATH:="/var/lib/elasticsearch"}
: ${ES_CLUSTER_NAME:="logstash-es"}
: ${ES_UNICAST_HOSTS:=localhost}

cat >> /etc/default/elasticsearch <<EOF

# Data path to be a volume
export ES_DATA_PATH="$ES_DATA_PATH"

# The name of the cluster
export ES_CLUSTER_NAME="$ES_CLUSTER_NAME"

# For cluster discovery
export ES_UNICAST_HOSTS="$ES_UNICAST_HOSTS"

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
