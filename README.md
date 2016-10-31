[![](https://images.microbadger.com/badges/image/khezen/logstash.svg)](https://hub.docker.com/r/khezen/logstash/)
# Supported tags and respective `Dockerfile` links

* `5.0.0`, `5.0`, `5`, `latest` [(5.0/Dockerfile)](https://github.com/Khezen/docker-logstash/blob/5.0/Dockerfile)

# What is logstash?
Logstash is an open source, server-side data processing pipeline that ingests data from a multitude of sources simultaneously, transforms it, and then sends it to your favorite “stash.” (Elasticsearch for example.)

[<img src="https://static-www.elastic.co/fr/assets/blt946bc636d34a70eb/icon-logstash-bb.svg?q=600" width="144" height="144">](https://www.elastic.co/fr/products/logstash)

# How To Use

## docker engine

```
docker run -d -p 5000:5000 - p 5001:5001 khezen/logstash:latest   
```

## docker-compose
```
version: '2'
services:
    elasticsearch:
        image: khezen/elasticsearch
        environment:
            elastic_pwd: changeme
            kibana_pwd: brucewayne
            logstash_pwd: heizenberg
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
            kibana_pwd: brucewayne
        ports:
             - "5601:5601"
        network_mode: bridge
        restart: always

    logstash:
        links:
            - elasticsearch
        image: khezen/logstash:5
        environment:
            logstash_pwd: heizenberg
        ports:
             - "5000:5000"
             - "5001:5001"
        network_mode: bridge
        restart: always

```
# Environment Variables

##### heap_size | `1g`
Defines the maximum memory allocated to logstash.

##### logstash_pwd | `changeme`
password for elasticsearch built-in user *logstash*.

##### elasticsearch_host | `elasticseach`
Elasticsearch hostname.

##### elasticsearch_port | `9200`
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
		hosts => "${elasticsearch_host}:${elasticsearch_port}"
		user => "logstash"
		password => "${logstash_pwd}"
	}
}
```

# User Feedback
## Issues
If you have any problems with or questions about this image, please ask for help through a [GitHub issue](https://github.com/Khezen/docker-logstash/issues).