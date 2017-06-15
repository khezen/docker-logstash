#!/bin/bash

set -m

/run/miscellaneous/restore_config.sh
/run/miscellaneous/wait_for_elasticsearch.sh

# Run as user "logstash" if the command is "logstash"
if [ "$1" = 'logstash' ]; then
	set -- gosu logstash "$@"
	LS_JAVA_OPTS="-Xms$HEAP_SIZE -Xmx$HEAP_SIZE" $@ &
else
	$@ &
fi

fg
