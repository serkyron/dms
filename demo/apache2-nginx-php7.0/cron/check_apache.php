<?php 

	/* Check sites-enabled */
	$dir    = '/etc/apache2/sites-enabled';
	$files = scandir($dir);
	unset($files[0]);
	unset($files[1]);

	foreach ($files as $key => &$file) {
		$modifiedTime = filemtime($dir."/".$file);
		$file = [
			'name' => $file,
			'path' => $dir."/".$file,
			'modified' => $modifiedTime
		];
		if (time() - $modifiedTime <= 60)
			exit(1);
	}

	/* Check apache2 conf */
	if (time() - filemtime('/etc/apache2/apache2.conf') <= 60)
			exit(1);

	/* Check ports.conf */
	if (time() - filemtime('/etc/apache2/ports.conf') <= 60)
			exit(1);

	/* Check remote ip */
	if (time() - filemtime('/etc/apache2/conf-available/remoteip.conf') <= 60)
			exit(1);

	/* Check php.ini */
	if (time() - filemtime('/etc/php/7.0/apache2/php.ini') <= 60)
			exit(1);

	exit(0);
?>