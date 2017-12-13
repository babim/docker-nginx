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

RUN mkdir -p /etc-start/nginx \
	&& cp -R /etc/nginx/* /etc-start/nginx
	
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Define default command.
CMD ["nginx", "-g", "daemon off;"]

# Expose ports.
EXPOSE 80 443
