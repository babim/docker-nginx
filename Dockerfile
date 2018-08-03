FROM babim/ubuntubase

# Download option
## ubuntu/debian
RUN apt-get update && \
    apt-get install -y wget bash gnupg && cd / && wget --no-check-certificate https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20SCRIPT%20AUTO/option.sh && \
    chmod 755 /option.sh

RUN nginx=stable && \
    echo "deb http://ppa.launchpad.net/nginx/$nginx/ubuntu xenial main" > /etc/apt/sources.list.d/nginx-$nginx.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C300EE8C && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install curl software-properties-common -yq && \
    apt-get update && apt-get install -y --force-yes nginx && \
    chown -R www-data:www-data /var/lib/nginx && \
    apt-get purge -y apache*

# Define mountable directories.
VOLUME ["/etc/nginx", "/var/log/nginx", "/var/www/"]

# Define working directory.
WORKDIR /etc/nginx

# Copy include file
COPY include /etc/nginx/include

# prepare etc start
RUN [[ ! -d /etc/nginx ]] || mkdir -p /etc-start/nginx && \
    [[ ! -d /etc/nginx ]] || cp -R /etc/nginx/* /etc-start/nginx && \
    [[ ! -d /var/www ]] || mkdir -p /etc-start/www && \
    [[ ! -d /var/www ]] || cp -R /var/www/* /etc-start/www
	
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "'daemon off;'"]

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# Expose ports.
EXPOSE 80 443
