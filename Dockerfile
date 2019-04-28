FROM babim/nginx:base

ENV PHP_VERSION 7.2
ENV LARAVEL true
RUN curl -s https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20PHP%20install/nginx_install.sh | bash

# Define mountable directories.
VOLUME ["/etc/nginx", "/var/log/nginx", "/var/www", "/etc/php"]

# Expose ports.
EXPOSE 80 443
