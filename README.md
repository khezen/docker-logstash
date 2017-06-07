[![](https://images.microbadger.com/badges/image/khezen/logstash.svg)](https://hub.docker.com/r/khezen/logstash/)
# Supported tags and respective `Dockerfile` links

* `2.4.1`, `2.4`, `2` [(2.4/Dockerfile)](https://github.com/Khezen/docker-logstash/blob/2.4/Dockerfile)
* `5.1.2`, `5.1` [(5.1/Dockerfile)](https://github.com/Khezen/docker-logstash/blob/5.1/Dockerfile)
* `5.2.2`, `5.2` [(5.2/Dockerfile)](https://github.com/Khezen/docker-logstash/blob/5.2/Dockerfile)
* `5.3.2`, `5.3` [(5.3/Dockerfile)](https://github.com/Khezen/docker-logstash/blob/5.3/Dockerfile)
* `5.4.1`, `5.4`, `5`, `latest` [(5.4/Dockerfile)](https://github.com/Khezen/docker-logstash/blob/5.4/Dockerfile)

# What is logstash?
Logstash is an open source, server-side data processing pipeline that ingests data from a multitude of sources simultaneously, transforms it, and then sends it to your favorite “stash.” (Elasticsearch for example.)

[<img src="https://static-www.elastic.co/fr/assets/blt946bc636d34a70eb/icon-logstash-bb.svg?q=600" width="144" height="144">](https://www.elastic.co/fr/products/logstash)

# How To Use

## docker engine

```
docker run -d -p 5000:5000 - p 5001:5001 khezen/logstash:latest   
```

## docker-compose

### [File Descriptors and MMap](https://www.elastic.co/guide/en/elasticsearch/guide/current/_file_descriptors_and_mmap.html)

run the following command on your host:
```
sysctl -w vm.max_map_count=262144
```
You can set it permanently by modifying `vm.max_map_count` setting in your `/etc/sysctl.conf`.

### docker-compose.yml
```
version: '2'
services:
    logstash:
        image: khezen/logstash:5
        environment:
            LOGSTASH_PWD: heizenberg
            ELASTICSEARCH_HOST: elasticsearch
            ELASTICSEARCH_PORT: 9200
        volumes:
            - /etc/logstash:/etc/logstash/conf.d
        ports:
             - "5000:5000"
             - "5001:5001"
        network_mode: bridge
        restart: always
```

or

```
version: '2'
services:
    elasticsearch:
        image: khezen/elasticsearch
        environment:
            ELASTIC_PWD: changeme
            KIBANA_PWD: brucewayne
            LOGSTASH_PWD: heizenberg
        volumes:
            - /data/elasticsearch:/usr/share/elasticsearch/data
            - /etc/elasticsearch:/usr/share/elasticsearch/config
        ports:
             - "9200:9200"
             - "9300:9300"
        network_mode: bridge
        restart: always

    kibana:
        links:
            - elasticsearch
        image: khezen/kibana
        environment:
            KIBANA_PWD: brucewayne
            ELASTICSEARCH_HOST: elasticsearch
            ELASTICSEARCH_PORT: 9200
        volumes:
            - /etc/kibana:/etc/kibana
        ports:
             - "5601:5601"
        network_mode: bridge
        restart: always

    logstash:
        links:
            - elasticsearch
        image: khezen/logstash:5
        environment:
            LOGSTASH_PWD: heizenberg
            ELASTICSEARCH_HOST: elasticsearch
            ELASTICSEARCH_PORT: 9200
        volumes:
            - /etc/logstash:/etc/logstash/conf.d
        ports:
             - "5000:5000"
             - "5001:5001"
        network_mode: bridge
        restart: always

```
# Environment Variables

##### HEAP_SIZE | `1g`
Defines the maximum memory allocated to logstash.

##### LOGSTASH_PWD | `changeme`
password for elasticsearch built-in user *logstash*.

##### ELASTICSEARCH_HOST | `elasticsearch`
Elasticsearch hostname.

##### ELASTICSEARCH_PORT | `9200`
Elasticsearch port.

# Default config

```
input {
	tcp {
		port => 5000
		codec => "json"
	}
	udp {
		port => 5001
		codec => "json"
	}
}

filter {
	date {
		match => [ "timestamp", "dd/MMM/YYYY:HH:mm:ss Z" ]
	}
	geoip {
    	source => "clientip"
 	}
  	useragent {
    	source => "agent"
    	target => "useragent"
  	}
}

output {
	elasticsearch {
		hosts => "${ELASTICSEARCH_HOST}:${ELASTICSEARCH_PORT}"
		user => "logstash"
		password => "${LOGSTASH_PWD}"
	}
}
```

# Configure Logstash

Configuration file is located in `/etc/logstash/logstash.conf` if you follow the same volume mapping as in docker-compose examples above.

You can find default config [there](https://github.com/Khezen/docker-logstash/blob/master/config/logstash.conf).

*NOTE*: It is possible to use [environment variables in logstash.conf](https://www.elastic.co/guide/en/logstash/current/environment-variables.html).

You can find help with logstash configuration [there](https://www.elastic.co/guide/en/logstash/current/configuration.html).

# User Feedback
## Issues
If you have any problems with or questions about this image, please ask for help through a [GitHub issue](https://github.com/Khezen/docker-logstash/issues).
