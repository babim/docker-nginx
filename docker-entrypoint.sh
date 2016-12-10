#!/bin/bash
set -e

if [ ! -f "/etc/nginx/nginx.conf" ]; then cp -R -f /etc-start/nginx/* /etc/nginx; fi

# set ID docker run
agid=${agid:-$auid}
auser=www-data

if [[ -z "${auid}" ]]; then
  echo "start"
elif [[ "$auid" = "0" ]] || [[ "$aguid" == "0" ]]; then
 echo "can't run in Root user. Default user still run."
else
  usermod -u $auid $auser
  groupmod -g $agid $auser
fi

exec "$@"
