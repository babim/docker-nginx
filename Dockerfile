FROM babim/nginx:base

RUN apt-get update && apt-get install -y --force-yes nginx php7.1-fpm \
    php7.1-cgi php7.1-cli php7.1-phpdbg libphp7.1-embed php7.1-dev php-xdebug sqlite3 \
    php7.1-curl php7.1-gd php7.1-imap php7.1-interbase php7.1-intl php7.1-ldap php7.1-mcrypt php7.1-readline php7.1-odbc \
    php7.1-pgsql php7.1-pspell php7.1-recode php7.1-tidy php7.1-xmlrpc php7.1 php7.1-json php-all-dev php7.1-sybase \
    php7.1-sqlite3 php7.1-mysql php7.1-opcache php7.1-bz2 php7.1-mbstring php7.1-zip php-apcu php-imagick \
    php-memcached php-pear libsasl2-dev libssl-dev libsslcommon2-dev libcurl4-openssl-dev \
    php7.1-gmp php7.1-xml php7.1-bcmath php7.1-enchant php7.1-soap php7.1-xsl && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    ln -sf /usr/bin/php7.1 /etc/alternatives/php

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
    echo "extension=oci8.so" > /etc/php/7.1/fpm/conf.d/30-oci8.ini && \
    echo "extension=oci8.so" > /etc/php/7.1/cli/conf.d/30-oci8.ini && \
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
