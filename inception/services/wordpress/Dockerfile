FROM debian:buster

COPY tools/run.sh /tmp/run.sh

RUN chmod +x /tmp/run.sh

ENTRYPOINT ["/bin/bash", "/tmp/run.sh"]