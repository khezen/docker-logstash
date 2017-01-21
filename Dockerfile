FROM logstash:2.4

MAINTAINER Guillaume Simonneau <simonneaug@gmail.com>

LABEL Description="logstash elasticsearch"

RUN apt-get update -y && apt-get install curl -y

ENV LOGSTASH_PWD="changeme" \
    ELASTICSEARCH_HOST="elasticsearch" \
    ELASTICSEARCH_PORT="9200" \
    HEAP_SIZE="1g" \
    TS_PWD="changeme"

ADD ./src/ /run/
RUN chmod +x -R /run/

COPY ./conf.d /.backup/logstash/conf.d
RUN rm -f /etc/logstash/conf.d/logstash.conf

VOLUME /etc/logstash/conf.d

ENTRYPOINT ["/run/entrypoint.sh"]
CMD ["logstash", "-f /etc/logstash/conf.d/logstash.conf"]