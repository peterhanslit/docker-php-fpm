FROM ubuntu:14.04
MAINTAINER Federico Ramallo

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update 
RUN apt-get install -y  libpng12-dev libjpeg-dev php5-fpm php5-gd php5-mysql php-apc && \
                        php5-curl php5-gd php5-intl php-pear php5-imagick php5-imap     \
                        php5-mcrypt php5-memcache php5-ming php5-ps php5-pspell         \
                        php5-recode php5-sqlite php5-tidy php5-xmlrpc php5-xsl php5-curl
RUN rm -rf /var/lib/apt/lists/*
    
# php-fpm config
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g"                     /etc/php5/fpm/php.ini
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g"    /etc/php5/fpm/php.ini
RUN sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g"                /etc/php5/fpm/php.ini
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g"                        /etc/php5/fpm/php-fpm.conf
RUN sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php5/fpm/pool.d/www.conf
RUN sed -i -e 's/127.0.0.1:9000/9000/'                                         /etc/php5/fpm/pool.d/www.conf
RUN sed -i -e '/allowed_clients/d'                                             /etc/php5/fpm/pool.d/www.conf
RUN sed -i -e '/error_log/d'                                                   /etc/php5/fpm/pool.d/www.conf

RUN find /etc/php5/cli/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;

RUN mkdir -p /var/www/html
EXPOSE 9000
ENTRYPOINT /usr/sbin/php-fpm --nodaemonize
