#!/bin/bash

if [ ! -f /etc/logstash/conf.d/logstash.conf ]; then
    cp -a /.backup/conf.d/logstash.conf /etc/logstash/conf.d/logstash.conf
fi