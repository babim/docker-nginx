# docker-ubuntu-nginx

#Usage
```
docker run -d -p 80:80 babim/ubuntu-nginx:proxy
```
Attach persistent/shared directories
```
docker run -d -p 80:80 -v <sites-enabled-dir>:/etc/nginx/conf.d -v <certs-dir>:/etc/nginx/certs -v <log-dir>:/var/log/nginx -v <html-dir>:/var/www/html babim/ubuntu-nginx:proxy
```
After few seconds, open http://<host> to see the welcome page.


Volume:
```
/var/www
/etc/nginx
/etc/php
```

Environment
```
TIMEZONE
PHP_MEMORY_LIMIT
MAX_UPLOAD
PHP_MAX_FILE_UPLOAD
PHP_MAX_POST
MAX_INPUT_TIME
MAX_EXECUTION_TIME
```
with environment ID:
```
auid = user id
agid = group id
auser = username
Default: agid = auid
```
