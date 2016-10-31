FROM logstash:5.0

MAINTAINER Guillaume Simonneau <simonneaug@gmail.com>

LABEL Description="logstash elasticsearch x-pack"

COPY ./config /etc/logstash/conf.d

ENV logstash_pwd="changeme" \
    elasticsearch_host="elasticsearch" \
    elasticsearch_port="9200" \
    heap_size="1g"

ADD ./src/ /run/
RUN chmod +x -R /run/

ENTRYPOINT ["/run/entrypoint.sh"]
CMD ["-f /etc/logstash/conf.d/", "--config.reload.automatic"]