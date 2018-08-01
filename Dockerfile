FROM babim/ubuntubase

# Download option
## ubuntu/debian
RUN apt-get update && \
    apt-get install -y wget bash && cd / && wget --no-check-certificate https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20SCRIPT%20AUTO/option.sh && \
    chmod 755 /option.sh && apt-get purge -y wget

RUN nginx=stable && \
    echo "deb http://ppa.launchpad.net/nginx/$nginx/ubuntu xenial main" > /etc/apt/sources.list.d/nginx-$nginx.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C300EE8C && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install software-properties-common -yq && add-apt-repository ppa:ondrej/php -y && \
    apt-get update && apt-get install -y --force-yes nginx && \
    chown -R www-data:www-data /var/lib/nginx && \
    apt-get purge -y apache*

# Fix run suck
RUN mkdir -p /run/php/

RUN apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/**

# Define mountable directories.
VOLUME ["/etc/nginx", "/var/log/nginx", "/var/www", "/etc/php"]

# Copy include file
COPY include /etc/nginx/include

# create folder    
RUN [ -d /var/cache/nginx ] || mkdir -p /var/cache/nginx && \
    [ -d /var/log/nginx ] || mkdir -p /var/log/nginx

# prepare etc start
RUN [ -d /etc/nginx ] || mkdir -p /etc-start/nginx && \
    [ -d /etc/nginx ] || cp -R /etc/nginx/* /etc-start/nginx && \
    [ -d /etc/php ] || mkdir -p /etc-start/php && \
    [ -d /etc/php ] || cp -R /etc/php/* /etc-start/php && \
    [ -d /etc/apache2 ] || mkdir -p /etc-start/apache2 && \
    [ -d /etc/apache2 ] || cp -R /etc/apache2/* /etc-start/apache2 && \
    [ -d /var/www ] || mkdir -p /etc-start/www && \
    [ -d /var/www ] || cp -R /var/www/* /etc-start/www

COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "'daemon off;'"]

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# Expose ports.
EXPOSE 80 443
