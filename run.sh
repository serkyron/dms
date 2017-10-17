#!/bin/bash

touch demo/apache2-nginx-php5.6/cron/cron.log \
demo/apache2-nginx-php7.0/cron/cron.log \
proxy/cron/cron.log \
demo/database/cron/cron.log

touch prod/apache2-nginx-php5.6/cron/cron.log \
prod/apache2-nginx-php7.0/cron/cron.log \
proxy/cron/cron.log \
prod/database/cron/cron.log

chmod 666 demo/apache2-nginx-php5.6/cron/cron.log \
demo/apache2-nginx-php7.0/cron/cron.log \
proxy/cron/cron.log \
demo/database/cron/cron.log

chmod 666 prod/apache2-nginx-php5.6/cron/cron.log \
prod/apache2-nginx-php7.0/cron/cron.log \
proxy/cron/cron.log \
prod/database/cron/cron.log

docker-compose \
-f empty-docker-compose.yml \
\
-f demo/apache2-nginx-php5.6/docker/docker-compose.yml \
-f demo/apache2-nginx-php7.0/docker/docker-compose.yml \
-f demo/database/docker/docker-compose.yml \
\
-f prod/apache2-nginx-php5.6/docker/docker-compose.yml \
-f prod/apache2-nginx-php7.0/docker/docker-compose.yml \
-f prod/database/docker/docker-compose.yml \
\
-f proxy/docker/docker-compose.yml \
-f db_interface/docker/docker-compose.yml \
up -d
