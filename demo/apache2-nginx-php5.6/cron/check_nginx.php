<?php 

	/* Check sites-enabled */
	$dir    = '/etc/nginx/sites-enabled';
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
	if (time() - filemtime('/etc/nginx/nginx.conf') <= 60)
			exit(1);

	exit(0);
?>