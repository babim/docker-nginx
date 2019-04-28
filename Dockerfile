FROM babim/alpinebase

RUN apk add --no-cache wget bash && cd / && wget --no-check-certificate https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20SCRIPT%20AUTO/option.sh && \
    chmod 755 /option.sh && apk del --purge wget

RUN apk add --no-cache nginx

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

# Define mountable directories.
VOLUME ["/etc/nginx", "/var/log/nginx", "/var/www"]

# Define working directory.
WORKDIR /etc/nginx

# Copy include file
COPY include /etc/nginx/include

# Define working directory.
RUN mkdir -p /etc-start/nginx \
	&& cp -R /etc/nginx/* /etc-start/nginx

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