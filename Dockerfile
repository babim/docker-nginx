FROM babim/debianbase

RUN nginx=stable && \
	echo 'deb http://nginx.org/packages/debian/ jessie nginx' > /etc/apt/sources.list.d/nginx-$nginx.list \
	&& echo 'deb-src http://nginx.org/packages/debian/ jessie nginx' >> /etc/apt/sources.list.d/nginx-$nginx.list \
	&& wget http://nginx.org/keys/nginx_signing.key -O- |apt-key add - \
	&& apt-get update \
	&& apt-get install -y nginx --force-yes \
	&& rm -rf /var/lib/apt/lists/**

# Define mountable directories.
VOLUME ["/etc/nginx", "/var/log/nginx", "/var/www/"]

# Define working directory.
WORKDIR /etc/nginx

# Copy include file
COPY include /etc/nginx/include

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

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# Expose ports.
EXPOSE 80 443
