#!/bin/bash

ps auxw | grep mysql | grep -v grep > /dev/null
if [ $? != 0 ]; then
    /etc/init.d/mysql start > /dev/null
    echo "$(date) - mysql started"
else
	data=$(/usr/bin/php -q /tmp/check_mysql.php);
	if [ $? != 0 ] 
	then
		/etc/init.d/mysql reload > /dev/null
		echo "$(date) - mysql reloaded"
	fi
fi