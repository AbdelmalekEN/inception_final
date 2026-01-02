FROM debian:bullseye
RUN apt-get update -y && apt-get install -y mariadb-server && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /var/run/mysqld && chown -R mysql:mysql /var/run/mysqld /var/lib/mysql && chmod 777 /var/run/mysqld
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY tools/init_db.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init_db.sh
EXPOSE 3306
CMD ["init_db.sh"]