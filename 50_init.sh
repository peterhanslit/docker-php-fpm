#!/bin/bash

echo 'running php5-fpm'
php5-fpm --nodaemonize --fpm-config /etc/php5/fpm/php-fpm.conf &

echo 'showing nginx log'
mkdir -p /var/log/nginx/
tail --follow=name --retry /var/log/nginx/error.log &


echo 'running nginx'
nginx
