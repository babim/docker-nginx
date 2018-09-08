FROM babim/ubuntubase:18.04

# Download option
## ubuntu/debian
RUN apt-get update && \
    apt-get install -y wget bash gnupg software-properties-common && cd / && wget --no-check-certificate https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20SCRIPT%20AUTO/option.sh && \
    chmod 755 /option.sh

RUN apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/**
