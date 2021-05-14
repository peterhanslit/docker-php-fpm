#!/bin/bash

echo 'running php-fpm7.4'
php-fpm7.4 --nodaemonize --fpm-config /etc/php/7.4/fpm/php-fpm.conf &

echo 'showing nginx log'
mkdir -p /var/log/nginx/
touch /var/log/nginx/error.log
tail --follow=name --retry /var/log/nginx/error.log &


echo 'running nginx'
nginx
