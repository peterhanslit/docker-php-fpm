#!/bin/bash

echo 'running php5-fpm'
php5-fpm --nodaemonize --fpm-config /etc/php5/fpm/php-fpm.conf &

echo 'showing nginx log'
tail -f /var/log/nginx/error.log &

echo 'running nginx'
nginx
