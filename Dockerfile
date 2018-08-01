FROM babim/nginx:base

RUN apt-get update && apt-get install -y --force-yes nginx && \
    curl -s https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20PHP%20install/php5.6.sh | bash

# Fix run suck
RUN mkdir -p /run/php/

RUN apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/**

# Define mountable directories.
VOLUME ["/etc/nginx", "/var/log/nginx", "/var/www", "/etc/php"]

ENTRYPOINT ["/start.sh"]
CMD ["nginx", "-g", "'daemon off;'"]

# Expose ports.
EXPOSE 80 443
