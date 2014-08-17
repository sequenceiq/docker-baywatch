#!/bin/bash

service elasticsearch start
service nginx start
service logstash start
### CLIENT ONLY BEGING ###
service logstash-forwarder start
service collectd start
#service logstash-forwarder status
#/opt/logstash-forwarder/bin/logstash-forwarder -config /etc/logstash-forwarder -spool-size 100
### CLIENT ONLY END ###

if [[ $1 == "-d" ]]; then
  while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi


CMD ["/etc/bootstrap.sh", "-d"]
