#!/bin/bash

ps auxw | grep nginx | grep -v grep > /dev/null
if [ $? != 0 ]; then
    /etc/init.d/nginx start > /dev/null
    echo "$(date) - nginx started"
else
	data=$(/usr/bin/php -q /tmp/check_nginx.php);
	if [ $? != 0 ] 
	then
		/etc/init.d/nginx reload > /dev/null
		echo "$(date) - nginx reloaded"
	fi
fi