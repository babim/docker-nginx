#!/bin/bash
set -e

if [ -z "`/etc/nginx/sites-enabled`" ] 
then
	cp -R /etc-start/nginx/sites-enabled/ /etc/nginx/sites-enabled
fi
if [ -z "`/etc/nginx/certs`" ] 
then
	cp -R /etc-start/nginx/certs/ /etc/nginx/certs
fi
if [ -z "`/etc/nginx/conf.d`" ] 
then
	cp -R /etc-start/nginx/conf.d/ /etc/nginx/conf.d
fi

exec "$@"
