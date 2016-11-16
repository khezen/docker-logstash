FROM logstash:5.0

MAINTAINER Guillaume Simonneau <simonneaug@gmail.com>

LABEL Description="logstash elasticsearch x-pack"

RUN apt-get update -y && apt-get install curl -y

ENV LOGSTASH_PWD="changeme" \
    ELASTICSEARCH_HOST="elasticsearch" \
    ELASTICSEARCH_PORT="9200" \
    HEAP_SIZE="1g"

ADD ./src/ /run/
RUN chmod +x -R /run/

COPY ./conf.d /.backup/conf.d
VOLUME /etc/logstash/conf.d


ENTRYPOINT ["/run/entrypoint.sh"]
CMD ["logstash", "-f /etc/logstash/conf.d/logstash.conf", "--config.reload.automatic"]