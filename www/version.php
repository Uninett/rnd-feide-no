<?php

	print_r("Environment printing\n\n");
	$CBUILDNUM = getenv('CBUILDNUM');
	$CBRANCH = getenv('CBRANCH');

	print_r("CBUILDNUM\n");
	print_r($CBUILDNUM);
	print_r("\n\nCBRANCH\n");
	print_r($CBRANCH);
	
?>