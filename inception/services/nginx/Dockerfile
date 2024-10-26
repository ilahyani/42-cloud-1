FROM debian:buster

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y nginx \
    && apt-get install -y openssl 

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt -subj "/CN=MA"

COPY conf/nginx.conf /etc/nginx/conf.d/

ENTRYPOINT [ "nginx", "-g", "daemon off;" ]