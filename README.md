# docker-ubuntu-nginx
Thanks docker-nginx

#Base Docker Image

    ubuntu

#Installation

    Install Docker.

#Usage

docker run -d -p 80:80 babim/ubuntu-nginx:proxy

Attach persistent/shared directories

docker run -d -p 80:80 -v <sites-enabled-dir>:/etc/nginx/conf.d -v <certs-dir>:/etc/nginx/certs -v <log-dir>:/var/log/nginx -v <html-dir>:/var/www/html babim/ubuntu-nginx:proxy

After few seconds, open http://<host> to see the welcome page.
