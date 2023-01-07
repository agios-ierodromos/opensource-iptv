FROM webdevops/php-nginx:8.2-alpine

ENV WEB_DOCUMENT_ROOT=/app/public
ENV PHP_DISMOD=bz2,calendar,exiif,ffi,intl,gettext,ldap,mysqli,imap,pdo_pgsql,pgsql,soap,sockets,sysvmsg,sysvsm,sysvshm,shmop,xsl,gd,apcu,vips,yaml,imagick,mongodb,amqp

WORKDIR /app

COPY . .

RUN export COMPOSER_ALLOW_SUPERUSER=1 \
    && composer install \
        --ignore-platform-reqs \
        --no-interaction \
        --no-plugins \
        --no-scripts \
        --prefer-dist \
        --no-dev

RUN echo "UTC" > /etc/timezone

# Ensure all of our files are owned by the same user and group.
RUN chown -R application:application .

RUN apk add bash
RUN sed -i 's/bin\/ash/bin\/bash/g' /etc/passwd

COPY .docker/php.ini /opt/docker/etc/php/php.ini

COPY .docker/nginx-laravel.conf /opt/docker/etc/nginx/vhost.common.d/20-laravel.conf
COPY .docker/nginx-http.conf /opt/docker/etc/nginx/conf.d/20-nginx.conf
COPY .docker/nginx-main.conf /opt/docker/etc/nginx/global.conf

COPY .docker/supervisord-laravel.conf /opt/docker/etc/supervisor.d/laravel.conf

COPY .docker/artisan-bootstrap.sh /opt/docker/provision/bootstrap.d/artisan.sh
COPY .docker/artisan-entrypoint.sh /opt/docker/provision/provision/entrypoint.d/artisan.sh

RUN touch storage/logs/laravel.log
RUN chmod u=+srwX,g=+srwX,o=+rwX -R storage/logs/laravel.log

RUN mkdir /data
RUN chown application:application /data
RUN chmod u=+srwX,g=+srwX,o=rX -R /data

VOLUME /data

RUN chown -R application:application \
            storage \
            bootstrap/cache

RUN chmod u=+srwX,g=+srwX,o=rX -R storage
