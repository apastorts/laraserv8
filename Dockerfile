FROM ubuntu:20.04

LABEL Abel Pastor

##
# Container dependencies
##
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y apt-utils curl zip unzip git software-properties-common locales tzdata\
    && locale-gen en_US.UTF-8

##
# NGINX
##
RUN apt-get install -y nginx \
    && echo "daemon off;" >> /etc/nginx/nginx.conf

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

##
# Supervisor
##
RUN apt-get install -y supervisor

##
# PHP-FPM
##
RUN add-apt-repository -y ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y php8.0-fpm php8.0-cli php8.0-mcrypt php8.0-gd php8.0-mysql php8.0-sqlite \
       php8.0-pgsql php8.0-imap php8.0-memcached php8.0-mbstring php8.0-xml php8.0-curl \
    && mkdir /run/php

##
# Composer
##
RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer

##
# Cleanup apt
##
RUN apt-get remove -y --purge software-properties-common apt-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

##
# Configuration files
##
COPY conf/supervisord.conf /etc/supervisord.conf
COPY conf/nginx.conf /etc/nginx/sites-available/default

##
# Entrypoint setup
##
COPY conf/entrypoint.sh /bin/entrypoint.sh
RUN chmod +x /bin/entrypoint.sh

WORKDIR /var/www/html

ENTRYPOINT ["entrypoint.sh"]
