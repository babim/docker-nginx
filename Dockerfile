FROM babim/debianbase:ssh

ENV NGINX_VERSION 1.9.11-1~jessie

RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 \
	&& echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get install -y ca-certificates nginx=${NGINX_VERSION} gettext-base \
	&& rm -rf /var/lib/apt/lists/*

# Define mountable directories.
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/"]

# Define working directory.
WORKDIR /etc/nginx

# Copy include file
COPY phpparam.conf /etc/nginx/include/phpparam.conf
COPY rootowncloud.conf.conf /etc/nginx/include/rootowncloud.conf
COPY rootwordpressclean.conf /etc/nginx/include/rootwordpressclean.conf
COPY restrict.conf /etc/nginx/include/restrict.conf
COPY owncloud.conf /etc/nginx/include/owncloud.conf
COPY wordpress.conf /etc/nginx/include/wordpress.conf
COPY wordpressmulti.conf /etc/nginx/include/wordpressmulti.conf
COPY wpsupercache.conf /etc/nginx/include/wpsupercache.conf

RUN mkdir -p /etc-start/nginx/sites-enabled /etc-start/nginx/certs /etc-start/nginx/conf.d \
	&& cp -R /etc/nginx/sites-enabled /etc-start/nginx/sites-enabled \
	&& cp -R /etc/nginx/certs /etc-start/nginx/certs \
	&& cp -R /etc/nginx/conf.d /etc-start/nginx/conf.d
	
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Define default command.
CMD ["nginx", "-g", "daemon off;"]

# Expose ports.
EXPOSE 80 443
