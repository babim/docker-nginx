FROM babim/nginx:base

RUN wget --no-check-certificate -O - https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20PHP%20install/nginx_install.sh | bash

RUN apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/**

# Define mountable directories.
VOLUME ["/etc/nginx", "/var/log/nginx", "/var/www"]

ENTRYPOINT ["/start.sh"]
CMD ["supervisord", "-nc", "/etc/supervisor/supervisord.conf"]

# Expose ports.
EXPOSE 80 443