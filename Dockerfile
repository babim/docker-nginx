FROM babim/debianbase

RUN nginx=stable && \
	echo 'deb http://nginx.org/packages/debian/ jessie nginx' > /etc/apt/sources.list.d/nginx-$nginx.list \
	&& echo 'deb-src http://nginx.org/packages/debian/ jessie nginx' >> /etc/apt/sources.list.d/nginx-$nginx.list \
	&& wget http://nginx.org/keys/nginx_signing.key -O- |apt-key add - \
	&& apt-get update \
	&& apt-get install -y nginx --force-yes \
	&& rm -rf /var/lib/apt/lists/** \
	&& echo "daemon off;" >> /etc/nginx/nginx.conf

# Define mountable directories.
VOLUME ["/etc/nginx", "/var/log/nginx", "/var/www/"]

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

RUN mkdir /etc-start \
	&& mv /etc/nginx /etc-start/ && mkdir /etc/nginx
	
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Define default command.
CMD ["nginx"]

# Expose ports.
EXPOSE 80 443
