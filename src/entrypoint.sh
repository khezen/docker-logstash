#!/bin/bash

/run/perf.sh

set -m

if [ ! -f /etc/logstash/conf.d/logstash.conf ]; then
    cp -r /.backup/logstash/conf.d /etc/logstash/
fi

/run/wait_for_elasticsearch.sh

# Add logstash as command if needed
if [ "${1:0:1}" = '-' ]; then
	set -- logstash "$@"
fi

# Run as user "logstash" if the command is "logstash"
if [ "$1" = 'logstash' ]; then
	set -- gosu logstash "$@"
fi

sleep 20 

$@ &

fg