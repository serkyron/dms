#!/bin/bash

docker-compose \
-f empty-docker-compose.yml \
-f proxy/docker/docker-compose.yml \
-f db_interface/docker/docker-compose.yml \
\
-f demo/apache2-nginx-php5.6/docker/docker-compose.yml \
-f demo/apache2-nginx-php7.0/docker/docker-compose.yml \
-f demo/database/docker/docker-compose.yml \
\
-f prod/apache2-nginx-php5.6/docker/docker-compose.yml \
-f prod/apache2-nginx-php7.0/docker/docker-compose.yml \
-f prod/database/docker/docker-compose.yml \
down
