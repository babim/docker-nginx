FROM babim/nginx:base

RUN curl -s https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20PHP%20install/nginx_install.sh | bash

# Define mountable directories.
VOLUME ["/etc/nginx", "/var/log/nginx", "/var/www"]

# Expose ports.
EXPOSE 80 443