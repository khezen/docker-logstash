#!/bin/bash
sed -ri "s/hosts =>[^\r\n]*/hosts => \"$ELASTICSEARCH_HOST:$ELASTICSEARCH_PORT\"/" /etc/logstash/conf.d/logstash.conf
sed -ri "s/password =>[^\r\n]*/password => \"$LOGSTASH_PWD\"/" /etc/logstash/conf.d/logstash.conf