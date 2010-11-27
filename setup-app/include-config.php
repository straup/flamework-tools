<?php

	#
	# HEY LOOK! THESE ARE THE *DEFAULT* CONFIG SETTINGS FOR
	# IF YOU NEED TO CHANGE THINGS YOU SHOULD DO IT OVER IN:
	# ../../config/app.php
	#

	#
	# We assume this is declared in flamework/include/config.php
	# $GLOBALS['cfg'] = array();
	#

	$GLOBALS['cfg']['flamework_skip_init_config'] = 1;
	$GLOBALS['cfg']['site_disabled'] = 0;

	#
	# Feature flags
	# See also: http://code.flickr.com/blog/2009/12/02/flipping-out/
	#

	$GLOBALS['cfg']['enable_feature_api'] = 0;

	$GLOBALS['cfg']['enable_feature_signup'] = 1;
	$GLOBALS['cfg']['enable_feature_signin'] = 1;
	$GLOBALS['cfg']['enable_feature_account_delete'] = 1;
	$GLOBALS['cfg']['enable_feature_password_retrieval'] = 0;

	$GLOBALS['cfg']['enable_feature_geocoding'] = 1;

	#
	# Database stuff
	#

	$GLOBALS['cfg']['db_enable_poormans_slaves'] = 1;
	$GLOBALS['cfg']['db_enable_poormans_ticketing'] = 1;
	$GLOBALS['cfg']['db_enable_poormans_federation'] = 1;

	#
	# API stuff
	#

	# TBW

	#
	# Templates
	#

	$GLOBALS['cfg']['smarty_template_dir'] = APP_WWW_DIR . '/templates';
	$GLOBALS['cfg']['smarty_compile_dir'] = APP_WWW_DIR . '/templates_c';
	$GLOBALS['cfg']['smarty_compile'] = 1;

	#
	# App specific stuff
	#

	$GLOBALS['cfg']['abs_root_url'] = '';		# silence this so that it doesn't trip that code
							# that tries to work out server names and directories
	$GLOBALS['cfg']['auth_cookie_name'] = 'a';

	$GLOBALS['cfg']['pagination_per_page'] = 25;
	$GLOBALS['cfg']['pagination_spill'] = 5;

?>
