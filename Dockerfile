FROM babim/nginx:base

RUN apt-get update && apt-get install -y --force-yes nginx php5.6-fpm \
    php5.6-json php5.6-gd php5.6-sqlite curl php5.6-curl php5.6-ldap php5.6-mysql php5.6-pgsql \
    php5.6-imap php5.6-tidy php5.6-xmlrpc php5.6-zip php5.6-mcrypt php5.6-memcache php5.6-intl \
    php5.6-mbstring imagemagick php5.6-sqlite3 php5.6-sybase php5.6-bcmath php5.6-soap php5.6-xml \
    php5.6-phpdbg php5.6-opcache php5.6-bz2 php5.6-odbc php5.6-interbase php5.6-gmp php5.6-xsl

# install option for webapp (owncloud)
RUN apt-get install -y --force-yes imagemagick smbclient ffmpeg ghostscript openexr openexr openexr libxml2 gamin

# install oracle client extension
ENV ORACLE_VERSION 12.2.0.1.0
RUN apt-get install -y --force-yes wget unzip libaio-dev php5.6-dev php-pear
RUN wget http://media.matmagoc.com/oracle/instantclient-basic-linux.x64-$ORACLE_VERSION.zip && \
    wget http://media.matmagoc.com/oracle/instantclient-sdk-linux.x64-$ORACLE_VERSION.zip && \
    wget http://media.matmagoc.com/oracle/instantclient-sqlplus-linux.x64-$ORACLE_VERSION.zip && \
    unzip instantclient-basic-linux.x64-$ORACLE_VERSION.zip -d /usr/local/ && \
    unzip instantclient-sdk-linux.x64-$ORACLE_VERSION.zip -d /usr/local/ && \
    unzip instantclient-sqlplus-linux.x64-$ORACLE_VERSION.zip -d /usr/local/ && \
    ln -s /usr/local/instantclient_12_2 /usr/local/instantclient && \
    ln -s /usr/local/instantclient/libclntsh.so.12.1 /usr/local/instantclient/libclntsh.so && \
    ln -s /usr/local/instantclient/sqlplus /usr/bin/sqlplus && \
    echo 'instantclient,/usr/local/instantclient' | pecl install oci8-2.0.12 && \
    echo "extension=oci8.so" > /etc/php/5.6/fpm/conf.d/30-oci8.ini && \
    echo "extension=oci8.so" > /etc/php/5.6/cli/conf.d/30-oci8.ini && \
    rm -f instantclient-basic-linux.x64-$ORACLE_VERSION.zip instantclient-sdk-linux.x64-$ORACLE_VERSION.zip instantclient-sqlplus-linux.x64-$ORACLE_VERSION.zip

# Fix run suck
RUN mkdir -p /run/php/

RUN apt-get purge wget -y && \
    apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/**

# Define mountable directories.
VOLUME ["/etc/nginx", "/var/log/nginx", "/var/www", "/etc/php"]

# prepare etc start
RUN [ -d /etc-start ] || rm -rf /etc-start && \
    [ -d /etc/nginx ] || mkdir -p /etc-start/nginx && \
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
