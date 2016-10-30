#!/bin/bash
set -e

if [ -z "`ls /etc/nginx`" ] 
then
	cp -R /etc-start/nginx/* /etc/nginx
fi

nginx
#exec "$@"
