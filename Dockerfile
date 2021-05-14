FROM ubuntu:21.04
LABEL maintainer="philip@peterhansl.it"

ARG php_version=7.4
ARG max_upload=100M

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y  libpng-dev libjpeg-dev php${php_version}-fpm php${php_version}-gd php${php_version}-mysql php-apcu-bc && \
    apt-get install -y  php${php_version}-curl php${php_version}-intl php-pear php${php_version}-imagick php${php_version}-imap && \
    apt-get install -y  php${php_version}-memcache php${php_version}-ps php${php_version}-pspell && \
    apt-get install -y  php${php_version}-sqlite php${php_version}-tidy php${php_version}-xmlrpc php${php_version}-xsl php${php_version}-curl && \
    apt-get install -y  nginx && \
    rm -rf /var/lib/apt/lists/*
    
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
# RUN sed -i -e '/http {/a client_max_body_size 100m;' /etc/nginx/nginx.conf 

RUN ls -l /etc

# php-fpm config
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g"                     /etc/php/${php_version}/fpm/php.ini
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = ${max_upload}/g"    /etc/php/${php_version}/fpm/php.ini
RUN sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = ${max_upload}/g"                /etc/php/${php_version}/fpm/php.ini
RUN sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php/${php_version}/fpm/pool.d/www.conf
RUN sed -i -e '/allowed_clients/d'                                             /etc/php/${php_version}/fpm/pool.d/www.conf
RUN sed -i -e '/error_log/d'                                                   /etc/php/${php_version}/fpm/pool.d/www.conf
RUN find /etc/php/${php_version}/cli/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;


# prepare test script
RUN mkdir -p /var/www/
RUN echo "<?php phpinfo(); ?>" > /var/www/index.php
RUN chown -R www-data:www-data /var/www/


COPY default.conf /etc/nginx/sites-available/default

VOLUME /var/log/nginx
EXPOSE 80

ADD *.sh /
RUN chmod +x /*.sh

CMD for f in /*.sh; do $f ; done
