This is an ubuntu based php-fpm image that allows you to run any php application.
This image should be used behind a reverse proxy like nginx or apache.

# Start the test application

You can start the instance with this:

```
docker run -d -v /tmp/php-fpm-logs:/var/log/nginx --name=php-fpm -p 127.0.0.1:9000:80 framallo/php-fpm
```

I run a nginx instance on the host server. And this the config file you need

```
server {
    listen       80;
    server_name  tangosource.dev
    underscores_in_headers on;

    location / {
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;

        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Sendfile-Type X-Accel-Redirect;

        proxy_buffering off;
        proxy_pass http://0.0.0.0:9000;
    }

    server_tokens off;
    sendfile on;

    keepalive_timeout 65;

    # maximum file upload size (keep up to date when changing the corresponding site setting)
    client_max_body_size 100m ;

    gzip on;
    gzip_vary on;
    gzip_min_length 1000;
    gzip_comp_level 5;
    gzip_types application/json text/css application/x-javascript application/javascript;
}
```

# How to run a custom application


You need to create a new image that inherits from this one.

* add `FROM framallo/php-fpm` on your `Dockerfile`. 
* build your image and install the php application in `/var/www`

This is an example of a Dockerfile

```
FROM framallo/php-fpm

# here you should run all the commands to bootstrap your php application
RUN echo "<?php phpinfo(); ?>" > /var/www/index.php

VOLUME /var/www/
```

The VOLUME directive should be placed after you bootstrapp the application
