#!/bin/bash

set -m

/run/miscellaneous/perf.sh
/run/miscellaneous/restore_config.sh
/run/miscellaneous/wait_for_elasticsearch.sh

# Run as user "logstash" if the command is "logstash"
if [ "$1" = 'logstash' ]; then
	set -- gosu logstash "$@"
fi
$@ &

fg