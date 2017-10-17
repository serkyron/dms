#!/bin/bash

docker build -t demo_apache2-nginx-php5.6 ./demo/apache2-nginx-php5.6/docker \
	&& docker build -t demo_apache2-nginx-php7.0 ./demo/apache2-nginx-php7.0/docker \
	&& docker build -t nginx-reverse-proxy ./proxy/docker \
	&& docker build -t demo_maria_db ./demo/database/docker \
	&& docker build -t prod_apache2-nginx-php5.6 ./prod/apache2-nginx-php5.6/docker \
	&& docker build -t prod_apache2-nginx-php7.0 ./prod/apache2-nginx-php7.0/docker \
	&& docker build -t prod_maria_db ./prod/database/docker
