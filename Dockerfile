FROM ubuntu:14.04
MAINTAINER SequenceIQ

# Elastic search 1.1.1
# Logstash 1.4.2
# Kibana 3.0.1

RUN apt-get update && apt-get install -y software-properties-common

#Install Java 7
RUN add-apt-repository ppa:webupd8team/java -y
RUN apt-get update
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java7-installer


#Install Elasticsearch
RUN wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -
RUN echo 'deb http://packages.elasticsearch.org/elasticsearch/1.1/debian stable main' | tee /etc/apt/sources.list.d/elasticsearch.list
RUN apt-get update
RUN apt-get -y install elasticsearch=1.1.1
RUN echo "script.disable_dynamic: true" >> /etc/elasticsearch/elasticsearch.yml
#Workaround regarding ulimit privileges
RUN sed -i.bak '/MAX_OPEN_FILES" ]; then/,+4 s/^/#/' /etc/init.d/elasticsearch
RUN sed -i.bak '/MAX_LOCKED_MEMORY" ]; then/,+4 s/^/#/' /etc/init.d/elasticsearch
RUN sed -i.bak '/MAX_MAP_COUNT" ]; then/,+4 s/^/#/' /etc/init.d/elasticsearch

#ElasticHQ plugin ( http://192.168.59.103:9200/_plugin/HQ )
RUN cd /usr/share/elasticsearch/bin && ./plugin -install royrusso/elasticsearch-HQ

#Install Kibana
RUN cd /root && wget https://download.elasticsearch.org/kibana/kibana/kibana-3.0.1.tar.gz && tar xvf kibana-3.0.1.tar.gz
RUN mkdir -p /usr/share/kibana3 && cp -R /root/kibana-3.0.1/* /usr/share/kibana3/

#Install Nginx for kibana
RUN apt-get install -y nginx apache2-utils
ADD server/nginx.conf /etc/nginx/sites-available/default

#Install Logstash
RUN echo 'deb http://packages.elasticsearch.org/logstash/1.4/debian stable main' | sudo tee /etc/apt/sources.list.d/logstash.list
RUN apt-get update && apt-get install -y logstash=1.4.2-1-2c0f5a1

#Workaround regarding ulimit privileges
RUN sed -i.bak '/set ulimit as/,+2 s/^/#/' /etc/init.d/logstash

#Configure logstash
RUN mkdir -p /etc/pki/tls/certs && mkdir -p /etc/pki/tls/private
RUN cd /etc/pki/tls && openssl req -x509 -batch -nodes -days 3650 -newkey rsa:2048 -keyout private/logstash-forwarder.key -out certs/logstash-forwarder.crt

#Configure listener for logstash-forwarder aka lumberjack
ADD server/input-logstash-forwarder.conf /etc/logstash/conf.d/input-logstash-forwarder.conf
ADD server/input-collectd.conf /etc/logstash/conf.d/input-collectd.conf
ADD server/filter-syslog.conf /etc/logstash/conf.d/filter-syslog.conf
ADD server/filter-nginx_access.conf /etc/logstash/conf.d/filter-nginx_access.conf
ADD server/output.conf /etc/logstash/conf.d/output.conf


#### CLIENT-ONLY BEGIN ####
#Setup logstash-forwarder client !!! DEMO ONLY !!! MOVE to CLIENT
RUN echo 'deb http://packages.elasticsearch.org/logstashforwarder/debian stable main' | tee /etc/apt/sources.list.d/logstashforwarder.list
RUN apt-get update && apt-get install -y logstash-forwarder

#Add to initd
#wget https://raw.github.com/elasticsearch/logstash-forwarder/master/logstash-forwarder.init
ADD client/logstash-forwarder.init /etc/init.d/logstash-forwarder
RUN cd /etc/init.d/ &&  chmod +x logstash-forwarder

#Config
ADD client/logstash-forwarder /etc/logstash-forwarder

RUN apt-get install -y collectd collectd-utils
ADD client/collectd.conf /etc/collectd/collectd.conf

RUN apt-get install -y stress
#### CLIENT-ONLY END ####

#Bootstrap file
ADD bootstrap.sh /etc/bootstrap.sh
RUN chown root:root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

ENV BOOTSTRAP /etc/bootstrap.sh
