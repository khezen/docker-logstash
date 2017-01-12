#!/bin/bash
sed -ri "s/hosts =>[^\r\n]*/hosts => \"$ELASTICSEARCH_HOST:$ELASTICSEARCH_PORT\"/" /etc/logstash/conf.d/logstash.conf