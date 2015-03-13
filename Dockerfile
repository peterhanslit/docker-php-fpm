FROM ubuntu:14.04
MAINTAINER Federico Ramallo <framallo@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y  libpng12-dev libjpeg-dev php5-fpm php5-gd php5-mysql php-apc && \
    apt-get install -y  php5-curl php5-gd php5-intl php-pear php5-imagick php5-imap && \
    apt-get install -y  php5-mcrypt php5-memcache php5-ming php5-ps php5-pspell && \
    apt-get install -y  php5-recode php5-sqlite php5-tidy php5-xmlrpc php5-xsl php5-curl && \
    apt-get install -y  nginx && \
    rm -rf /var/lib/apt/lists/*
    
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN sed -i -e '/http {/a client_max_body_size 100M;' /etc/nginx/nginx.conf 

# php-fpm config
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g"                     /etc/php5/fpm/php.ini
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g"    /etc/php5/fpm/php.ini
RUN sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g"                /etc/php5/fpm/php.ini
RUN sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php5/fpm/pool.d/www.conf
RUN sed -i -e '/allowed_clients/d'                                             /etc/php5/fpm/pool.d/www.conf
RUN sed -i -e '/error_log/d'                                                   /etc/php5/fpm/pool.d/www.conf
RUN find /etc/php5/cli/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;


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
