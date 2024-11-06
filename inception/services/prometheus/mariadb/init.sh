#! /bin/bash

cat <<EOF > /home/config.my-cnf
[client]
user = $MYSQL_EXPORTER
password = $MYSQL_EXPORTER_PASSWORD
host = $PMA_HOST
EOF

exec /bin/mysqld_exporter --config.my-cnf=/home/config.my-cnf