#!/bin/bash

set -e

if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
    mariadbd --user=mysql &
    sleep 3

    mariadb -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"

    mariadb -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$(cat /run/secrets/db_password)';"

    mariadb -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';"

    mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$(cat /run/secrets/db_root_password)';"

    mariadb -e "FLUSH PRIVILEGES;"

    mysqladmin -u root -p"$(cat /run/secrets/db_root_password)" shutdown
fi

exec mariadbd --user=mysql --bind-address=0.0.0.0