#!/bin/bash

echo 'running php5-fpm'
php5-fpm --nodaemonize --fpm-config /etc/php5/fpm/php-fpm.conf &

echo 'running nginx'
nginx
