FROM babim/debianbase:ssh

RUN nginx=stable && \
	echo 'deb http://nginx.org/packages/debian/ jessie nginx' > /etc/apt/sources.list.d/nginx-$nginx.list \
	&& echo 'deb-src http://nginx.org/packages/debian/ jessie nginx' >> /etc/apt/sources.list.d/nginx-$nginx.list \
	&& wget http://nginx.org/keys/nginx_signing.key -O- |apt-key add - \
	&& apt-get update \
	&& apt-get install -y nginx --force-yes \
	&& rm -rf /var/lib/apt/lists/** \
	&& echo "\ndaemon off;" >> /etc/nginx/nginx.conf

# Define mountable directories.
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/"]

# Define working directory.
WORKDIR /etc/nginx

# Copy include file
COPY phpparam.conf /etc/nginx/include/phpparam.conf
COPY rootowncloud.conf /etc/nginx/include/rootowncloud.conf
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
CMD ["nginx", "-g;"]

# Expose ports.
EXPOSE 80 443
