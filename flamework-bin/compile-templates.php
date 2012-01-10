<?php

	$root = dirname(dirname(__FILE__));
	ini_set("include_path", "{$root}/www:{$root}/www/include");

	set_time_limit(0);

	# http://www.smarty.net/docs/en/api.compile.all.templates.tpl

	include("include/init.php");
	
	$GLOBALS['smarty']->compileAllTemplates('.txt', true);
	exit();
?>
