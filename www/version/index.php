<?php

	$data = [
		"build": getenv('CBUILDNUM'),
		"branch": getenv('CBRANCH'),
		"wordpressVersion": getenv('WORDPRESS_VERSION'),
	];
	header("Content-type: application/json; charset=utf-8");
	echo json_encode($data, JSON_PRETTY_PRINT);

?>
