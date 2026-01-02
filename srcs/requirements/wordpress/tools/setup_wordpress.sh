#!/bin/bash

set -e

cd /var/www/html
if [ ! -f wp-config.php ]; then
    wget https://wordpress.org/latest.tar.gz
    tar -xzvf latest.tar.gz --strip-components=1
    rm latest.tar.gz
    cp wp-config-sample.php wp-config.php
    sed -i "s/database_name_here/$MYSQL_DATABASE/" wp-config.php
    sed -i "s/username_here/$MYSQL_USER/" wp-config.php
    sed -i "s/password_here/$(cat $MYSQL_PASSWORD_FILE)/" wp-config.php
    sed -i "s/localhost/mariadb/" wp-config.php
    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp
    wp core install --url=$DOMAIN_NAME --title="$WORDPRESS_TITLE" --admin_user=$WORDPRESS_ADMIN_USER --admin_password=$WORDPRESS_ADMIN_PASSWORD --admin_email=$WORDPRESS_ADMIN_EMAIL --skip-email --allow-root
    wp user create $WORDPRESS_USER $WORDPRESS_USER_EMAIL --role=author --user_pass=$WORDPRESS_USER_PASSWORD --allow-root
    chown -R www-data:www-data /var/www/html
fi
exec php-fpm7.4 -y /etc/php/7.4/fpm/php-fpm.conf -F