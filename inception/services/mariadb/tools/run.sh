#!/bin/bash

sed -i 's/127.0.0.1/0.0.0.0/g' etc/mysql/mariadb.conf.d/50-server.cnf

service mysql start

echo "CREATE DATABASE IF NOT EXISTS ${DATABASE};" | mysql
echo "GRANT ALL PRIVILEGES ON ${DATABASE}.* TO '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';" | mysql
echo "CREATE USER '${MYSQL_EXPORTER}'@'%' IDENTIFIED BY '${MYSQL_EXPORTER_PASSWORD}' WITH MAX_USER_CONNECTIONS 3;" | mysql
echo "GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO '${MYSQL_EXPORTER}'@'%';" | mysql
echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@localhost IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';" | mysql

mysqladmin shutdown -uroot -p${MYSQL_ROOT_PASSWORD}

mysqld_safe