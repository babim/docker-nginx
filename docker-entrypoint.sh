#!/bin/bash
export TERM=xterm

if [ ! -f "/etc/nginx/nginx.conf" ]; then cp -R -f /etc-start/nginx/* /etc/nginx; fi

# set ID docker run
agid=${agid:-$auid}
auser=${auser:-www-data}

	# create folder
	[[ ! -d /var/cache/nginx ]] || chown -R $auser /var/cache/nginx
	[[ ! -d /var/log/nginx ]] || chown -R $auser /var/log/nginx

if [[ -z "${auid}" ]]; then
  echo "start"
elif [[ "$auid" = "0" ]] || [[ "$aguid" == "0" ]]; then
	echo "run in user root"
	auser=root
	#Set nginx user
	sed -i -e "/^user .*/cuser  $auser;" /etc/nginx/nginx.conf
	sed -i -e "/^#user .*/cuser  $auser;" /etc/nginx/nginx.conf
elif id $auid >/dev/null 2>&1; then
        echo "UID exists. Please change UID"
else
if id $auser >/dev/null 2>&1; then
        echo "user exists"
	sed -i -e "/^user .*/cuser  $auser;" /etc/nginx/nginx.conf
	sed -i -e "/^#user .*/cuser  $auser;" /etc/nginx/nginx.conf
	#export APACHE_RUN_USER=$auser
	#export APACHE_RUN_GROUP=$auser
	# usermod alpine
		#deluser $auser && delgroup $auser
		#addgroup -g $agid $auser && adduser -D -H -G $auser -s /bin/false -u $auid $auser
	# usermod ubuntu/debian
		usermod -u $auid $auser
		groupmod -g $agid $auser
else
        echo "user does not exist"
	#export APACHE_RUN_USER=$auser
	#export APACHE_RUN_GROUP=$auser
	# create user alpine
	#addgroup -g $agid $auser && adduser -D -H -G $auser -s /bin/false -u $auid $auser
	# create user ubuntu/debian
	groupadd -g $agid $auser && useradd --system --uid $auid --shell /usr/sbin/nologin -g $auser $auser
	sed -i -e "/^user .*/cuser  $auser;" /etc/nginx/nginx.conf
	sed -i -e "/^#user .*/cuser  $auser;" /etc/nginx/nginx.conf
fi

fi

# option with entrypoint
if [ -f "/option.sh" ]; then /option.sh; fi

# run PHP-fpm
if [ -f "/usr/bin/php-fpm5.6" ]; then php-fpm5.6 -D; fi
if [ -f "/usr/bin/php-fpm7.0" ]; then php-fpm7.0 -D; fi
if [ -f "/usr/bin/php-fpm7.1" ]; then php-fpm7.1 -D; fi
if [ -f "/usr/bin/php-fpm7.2" ]; then php-fpm7.2 -D; fi
