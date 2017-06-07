FROM logstash:5.4.1

MAINTAINER Guillaume Simonneau <simonneaug@gmail.com>

LABEL Description="logstash elasticsearch http_poller exec"

# install plugin dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
		apt-transport-https \
		libzmq3 \
    curl \
	&& rm -rf /var/lib/apt/lists/*

# Plugins
RUN /usr/share/logstash/bin/logstash-plugin install logstash-input-http_poller
RUN /usr/share/logstash/bin/logstash-plugin install logstash-input-exec
RUN /usr/share/logstash/bin/logstash-plugin install logstash-filter-json_encode

ADD ./src/ /run/
RUN chmod +x -R /run/

COPY ./conf.d /.backup/logstash/conf.d
RUN rm -f /etc/logstash/conf.d/logstash.conf

VOLUME /etc/logstash/conf.d

EXPOSE 5000

ENV LOGSTASH_PWD="changeme" \
    ELASTICSEARCH_HOST="elasticsearch" \
    ELASTICSEARCH_PORT="9200" \
    HEAP_SIZE="1g" \
    TS_PWD="changeme"

ENTRYPOINT ["/run/entrypoint.sh"]
CMD ["logstash", "-f /etc/logstash/conf.d/logstash.conf", "--config.reload.automatic"]
