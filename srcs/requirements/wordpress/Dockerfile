FROM debian:bullseye
RUN apt-get update -y && apt-get install -y php7.4 php7.4-fpm php7.4-mysql wget && rm -rf /var/lib/apt/lists/*
RUN mkdir /run/php
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY tools/setup_wordpress.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup_wordpress.sh
EXPOSE 9000
CMD ["setup_wordpress.sh"]