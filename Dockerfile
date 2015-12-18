FROM babim/debianbase

MAINTAINER "Duc Anh Babim" <ducanh.babim@yahoo.com>

RUN nginx=stable && \
    echo "deb http://ppa.launchpad.net/nginx/$nginx/debian jessie main" > /etc/apt/sources.list.d/nginx-$nginx.list && \
    wget http://nginx.org/keys/nginx_signing.key -O- |apt-key add – && \
    apt-get clean && \
    apt-get update && \
    apt-get install nano nginx -y --force-yes && \
    echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
    chown -R www-data:www-data /var/lib/nginx

# Define mountable directories.
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]

# Define working directory.
WORKDIR /etc/nginx

ENV LC_ALL C.UTF-8

# Define default command.
CMD ["nginx"]

# Expose ports.
EXPOSE 80
EXPOSE 443
