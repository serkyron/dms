<?php 

	/* Check maria conf */
	if (time() - filemtime('/etc/mysql/my.cnf') <= 60)
			exit(1);

	if (time() - filemtime('/etc/mysql/debian.cnf') <= 60)
			exit(1);

	exit(0);
?>