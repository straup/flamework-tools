<?php

	#
	# $Id$
	#

	# This is painful, but you're not really expected to have
	# to think about it if you're doing a plain vanilla install

	define('APP_WWW_DIR', dirname(dirname(__FILE__)));

	define('APP_CONFIG_DIR', dirname(APP_WWW_DIR) . '/config');
	define('APP_FLAMEWORK_DIR', dirname(APP_WWW_DIR) . '/ext/flamework');

	include(APP_FLAMEWORK_DIR . '/include/config.php');

	include(APP_WWW_DIR."/include/config.php");

	if (file_exists(APP_CONFIG_DIR . '/app.php')){
		include(APP_CONFIG_DIR . '/app.php');
	}

	if ($GLOBALS['cfg']['enable_feature_api']){
		include_once(APP_WWW_DIR . '/include/config-api.php');
	}

	#
	# Hey look! Running code. (We do this here so that paths/URLs will
	# still work if the site has been disabled.)
	#

	#
	# First, ensure that 'abs_root_url' is both assigned and properly
	# set up to run out of user's public_html directory (if need be).
	#

	$server_url = $GLOBALS['cfg']['abs_root_url'];

	if (! $server_url){
		$scheme = ($_SERVER['SERVER_PORT'] == 443) ? "https" : "http";
		$server_url = "{$scheme}://{$_SERVER['SERVER_NAME']}/";
	}

	$cwd = '';

	if ($parent_dirname = rtrim(dirname($_SERVER['SCRIPT_NAME']), '/')){

		$parts = explode("/", $parent_dirname);
		$cwd = implode("/", array_slice($parts, 1));
	}

	$GLOBALS['cfg']['abs_root_url'] = $server_url . $cwd;
	$GLOBALS['cfg']['safe_abs_root_url'] = $GLOBALS['cfg']['abs_root_url'];

	$GLOBALS['cfg']['auth_cookie_domain'] = parse_url($GLOBALS['cfg']['abs_root_url'], 1);

	#
	# Go, flamework! Go!!
	#

	include_once(APP_FLAMEWORK_DIR . '/include/init.php');

	#################################################################

	# loadlib("filter");

	#################################################################

	# This is a shim in the absence of a saner and
	# plain-old function-y way to use lib_filter...

	function filter_strict($str){

		$filter = new lib_filter();
		$filter->allowed = array();
		return $filter->go($str);
	}

	#################################################################

	function smarty_function_pagination(){
		echo($GLOBALS['smarty']->fetch('inc_pagination.txt'));
	}

	#################################################################

	function smarty_modifier_possess($str){

		$ending = (preg_match("/s$/", $str)) ? "'" : "'s";

		return $str . $ending;
	}

	$GLOBALS['smarty']->register_modifier('possess', 'smarty_modifier_possess');

	#################################################################

	# http://www.php.net/manual/en/function.parse-url.php#90365

	function parse_url_re($url){

		$r  = "(?:([a-z0-9+-._]+)://)?";
		$r .= "(?:";
		$r .=   "(?:((?:[a-z0-9-._~!$&'()*+,;=:]|%[0-9a-f]{2})*)@)?";
		$r .=   "(?:\[((?:[a-z0-9:])*)\])?";
		$r .=   "((?:[a-z0-9-._~!$&'()*+,;=]|%[0-9a-f]{2})*)";
		$r .=   "(?::(\d*))?";
		$r .=   "(/(?:[a-z0-9-._~!$&'()*+,;=:@/]|%[0-9a-f]{2})*)?";
		$r .=   "|";
		$r .=   "(/?";
		$r .=     "(?:[a-z0-9-._~!$&'()*+,;=:@]|%[0-9a-f]{2})+";
		$r .=     "(?:[a-z0-9-._~!$&'()*+,;=:@\/]|%[0-9a-f]{2})*";
		$r .=    ")?";
		$r .= ")";
		$r .= "(?:\?((?:[a-z0-9-._~!$&'()*+,;=:\/?@]|%[0-9a-f]{2})*))?";
		$r .= "(?:#((?:[a-z0-9-._~!$&'()*+,;=:\/?@]|%[0-9a-f]{2})*))?";

		if (! preg_match("`$r`i", $url, $match)){
			return array( 'ok' => 0 );
		}

		$parts = array(
			"ok" => 1,
			"scheme"=>'',
			"userinfo"=>'',
			"authority"=>'',
			"host"=> '',
			"port"=>'',
			"path"=>'',
			"query"=>'',
			"fragment"=>''
		);

		switch (count($match)){
			case 10: $parts['fragment'] = $match[9];
			case 9: $parts['query'] = $match[8];
			case 8: $parts['path'] =  $match[7];
			case 7: $parts['path'] =  $match[6] . $parts['path'];
			case 6: $parts['port'] =  $match[5];
			case 5: $parts['host'] =  $match[3]?"[".$match[3]."]":$match[4];
			case 4: $parts['userinfo'] =  $match[2];
			case 3: $parts['scheme'] =  $match[1];
		}

		$parts['authority'] = ($parts['userinfo']?$parts['userinfo']."@":"") .
		$parts['host'] .
		($parts['port'] ? ":" . $parts['port'] : "");

		return $parts;
	}

	#################################################################

?>
