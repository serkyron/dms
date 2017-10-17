<h1>Docker management system</h1>

Never delete empty-docker-compose.yml! 
Its presence is necessary to build relative paths due to the following issue:
https://github.com/docker/compose/issues/3874

<h2>What is it?</h2>

This project is a ready to use infrastructure for your web server, mainly oriented to PHP projects. It was originally developed for our company needs. Default php containers are optimised for 1C Bitrix CMS. 

The system consists of two parts: demo and prod. 

Each part has a separate database server.
There is a phpmyadmin container that has access to both database servers.

Demo and prod parts are exactly the same. They both have: 
<ul>
  <li>2 web server containers, one with php 5.6, another with php 7.0 </li>
  <li>their own projects </li>
  <li>their own configuration files</li>
</ul>

<h2>How it works?</h2>

There is a container with an nginx proxy server that handles the request first. If the required server name matches any from its configuration files nginx redirects the request to the web server container as specified in the configuration file.

Example: 

	server {
		listen 80;
		server_name example.ru www.example.ru;

		location / {
			proxy_pass http://demo_php7_web;
		}
	}

There is a bundle of apache2 and nginx running into each web server container. Nginx receives the request first. The request will be handled by nginx if static assets are requested or passed to apache otherwise. 

<h2>Features</h2>

<ul>
	<li>There is a cron task to watch apache2 and nginx conf files. If changes are detected, the web server gets reloaded. Cron check period is 1 minute. So, if you changed a conf file, wait a minute for it to reload.</li>
	<li>Every web server container has a "developer" user</li>
	<li>Cron, Apache2 and Nginx run under "developer" user</li>
	<li>SSL support. Check exmaple_ssl and example_ssl.conf in example_hosts.</li>
	<li>Server side files compression configured</li>
	<li>Installed: curl, rsyslog, htop, xvfb, libfontconfig, wkhtmltopdf, jpegoptim, optipng</li>
</ul>

<h2>Project structure</h2>

<ul>
  	<li>bin - put your binaries in here. Gets mounted to web server containers.</li>
	<li>db_interface - contains conf file and docker-compose for phpmyadmin</li>
	<li>demo - check demo section bellow</li>
	<li>exmaple_hosts - example configuration files for nginx, apache2 and nginx proxy</li>
	<li>prod - check prod section bellow</li>
	<li>proxy - check proxy section bellow</li>
</ul>

<h3>Demo</h3>

<ul>
	<li>apache2-nginx-php5.6 container</li>
	<li>apache2-nginx-php7.0 container</li>
	<li>database</li>
	<li>hosts - contains configuration files for apache2 and nginx. These files run across web server container within demo part.</li>
	<li>www - should contain folders with your projects. <b>A project folder should have 'data' folder and 'logs' folder. Put your project files in data.</b></li>
</ul>

<h3>Prod</h3>

Has exactly the same structure and logic as demo part.

<h3>Proxy</h3>

<ul>
	<li>certs - put your ssl related file into this folder</li>
	<li>conf - contains nginx configuration file</li>
	<li>cron - has a crontab to reload nginx proxy if any conf changes have been found</li>
	<li>docker - Dockerfile and docker-compose
	<li>sites-enabled - put your sites configuration here for nginx proxy. Check example_hosts</li>
</ul>

<h2>Usage</h2>

<p>When configuring the system in production you might need to use SSL, check example_ssl and example_ssl.conf in example_hosts.<br>
Remember to configure proxy with SSL too. Check proxy/example_ssl in example_hosts.<br>
If you're having troubles configuring the system for production, contact me by email: <a href="mailto:serkyron@gmail.com">serkyron@gmail.com</a><br></p>

<p>Follow these steps to start using the system for local development. Create your 'example' host. <br></p>

<ol>
	<li>git clone this repository</li>
	<li>./build.sh</li>
	<li>cd demo/hosts</li>
	<li>
		put 'example.conf' file in to sites-enabled-apache with the following content:
		
		Listen 8080

		<VirtualHost *:8080>
			ServerName example
			ServerAlias www.example.ru

			ServerAdmin webmaster@localhost
			DocumentRoot /var/www/example/data

			<Directory /var/www/example/data>
			Allowoverride All
		    </Directory>

			ErrorLog /var/www/example/logs/apache.error.log
			CustomLog /var/www/example/logs/apache.access.log combined_with_x_real_ip
		</VirtualHost>
</li>
	<li>
		put 'example' file in to sites-enabled-nginx with the following content:
		
		server {
			listen 80;
			listen [::]:80;

			server_name www.example.ru example;

			root /var/www/example/data;
			index index.php index.html;

			# Add stdout logging

			  error_log /dev/stdout info;
			  access_log /dev/stdout;

			  #error_page 404 /404.html;

			  # redirect server error pages to the static page /50x.html
			  #
			  error_page 500 502 503 504 /50x.html;
			  location = /50x.html {
			    root /usr/share/nginx/html;
			  }

			  access_log /var/www/example/logs/nginx.access.log combined_with_x_real_ip;
			  error_log /var/www/example/logs/nginx.error.log;

			   location / {
			      proxy_pass          http://localhost:8080/;
			      proxy_set_header    Host           $host;
			      proxy_set_header    X-Forwarded-For 82.202.249.25;
			      proxy_redirect      off;
			   }

			   location ~*^.+\.(jpg|jpeg|gif|png|ico|css|zip|tgz|gz|rar|bz2|doc|xls|exe|pdf|ppt|txt|tar|wav|bmp|rtf|js|html)$ {
			      root   /var/www/example/data;
			      add_header Source nginx; 
			   }
		}
		
</li>
	<li>cd .. (go back to demo folder)</li>
	<li>cd www</li>
	<li>mkdir example</li>
	<li>cd exmaple</li>
	<li>mkdir data</li>
	<li>mkdir logs</li>
	<li>echo "<? phpinfo() ?>" > data/index.php</li>
	<li>cd ../../../proxy/sites-enabled/</li>
	<li>
		create 'example' file with the following content:
	
		server {
			listen 80;

			server_name example example.ru www.example.ru;

			location / {
				proxy_pass http://demo_php7_web;
			}
		}		
</li>
	<li>cd ../../</li>
	<li>./run.sh</li>
	<li>Add '127.0.0.1  example' entry to your /etc/hosts file.</li>
	<li>Open http://example in browser</li>
</ol>
