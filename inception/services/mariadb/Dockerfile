FROM debian:buster

RUN apt-get update && apt-get upgrade -y  \
    && apt-get install -y mariadb-server

COPY tools/run.sh /tmp/run.sh

RUN chmod +x /tmp/run.sh

ENTRYPOINT ["/tmp/run.sh"]