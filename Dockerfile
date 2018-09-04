FROM babim/ubuntubase

# Download option
## ubuntu/debian
RUN apt-get update && \
    apt-get install -y wget curl bash gnupg software-properties-common && cd / && wget --no-check-certificate https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20SCRIPT%20AUTO/option.sh && \
    chmod 755 /option.sh

# install nginx
RUN curl -s https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20PHP%20install/nginx.sh | bash

RUN apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/**

# Define mountable directories.
VOLUME ["/etc/nginx", "/var/log/nginx", "/var/www", "/etc/php"]

# Copy include file
COPY include /etc/nginx/include

#ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "'daemon off;'"]

# Expose ports.
EXPOSE 80 443
