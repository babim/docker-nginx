#!/bin/bash
set -e

if [ -z "`ls /etc/nginx/sites-enabled`" ] 
then
	cp -R /etc-start/nginx/sites-enabled/ /etc/nginx/sites-enabled
fi
if [ -z "`ls /etc/nginx/certs`" ] 
then
	cp -R /etc-start/nginx/certs/ /etc/nginx/certs
fi
if [ -z "`ls /etc/nginx/conf.d`" ] 
then
	cp -R /etc-start/nginx/conf.d/ /etc/nginx/conf.d
fi

exec "$@"
