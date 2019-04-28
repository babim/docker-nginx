FROM babim/alpinebase

RUN apk add --no-cache wget bash && cd / && wget --no-check-certificate https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20SCRIPT%20AUTO/option.sh && \
    chmod 755 /option.sh && apk del --purge wget

RUN apk add --no-cache nginx imagemagick \
	nano php7-fpm php7-json php7-gd php7-sqlite3 curl php7-curl php7-ldap php7-mysqli php7-pgsql php7-imap php7-bcmath \
	php7-xmlrpc php7-mcrypt php7-intl php7-zip php7-opcache php7-bz2 php7-odbc php7-soap \
	php7-xml php7-pear

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

# Define working directory.
WORKDIR /etc/nginx

# Copy include file
COPY include /etc/nginx/include

# Define mountable directories.
VOLUME ["/etc/nginx", "/var/log/nginx", "/var/www", "/etc/php7"]

# Define working directory.
RUN mkdir -p /etc-start/nginx /etc-start/php7\
	&& cp -R /etc/nginx/* /etc-start/nginx\
	&& cp -R /etc/php7/* /etc-start/php7

RUN deluser xfs && delgroup www-data && \
    addgroup -g 33 www-data && adduser -D -H -G www-data -s /bin/false -u 33 www-data
    
# Fix nginx.pid no suck file
RUN mkdir -p /run/nginx

COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Define default command.
CMD ["nginx", "-g", "daemon off;"]

# Expose ports.
EXPOSE 80 443