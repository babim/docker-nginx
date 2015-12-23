FROM babim/ubuntubase

MAINTAINER "Duc Anh Babim" <ducanh.babim@yahoo.com>

RUN nginx=stable && \
    echo "deb http://ppa.launchpad.net/nginx/$nginx/ubuntu trusty main" > /etc/apt/sources.list.d/nginx-$nginx.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C300EE8C && \
    apt-get clean && \
    apt-get update && \
    apt-get install nano nginx -y --force-yes && \
    echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
    chown -R www-data:www-data /var/lib/nginx

# Define mountable directories.
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/"]

# Define working directory.
WORKDIR /etc/nginx

ENV LC_ALL en_US.UTF-8
ENV TZ Asia/Ho_Chi_Minh
# Define default command.
CMD ["nginx"]

# Expose ports.
EXPOSE 80 443
