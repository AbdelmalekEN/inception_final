FROM debian:bullseye
RUN apt-get update -y && apt-get install -y nginx openssl && rm -rf /var/lib/apt/lists/*
COPY conf/nginx.conf /etc/nginx/sites-available/default
COPY tools/generate_ssl.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/generate_ssl.sh
EXPOSE 443
CMD ["generate_ssl.sh"]