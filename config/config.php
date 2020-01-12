<?php

$CONFIG = array (
  'htaccess.RewriteBase' => '/',
  'memcache.local' => '\\OC\\Memcache\\APCu',
  'trusted_domains' =>
  array (
    0 => '127.0.0.1',
    1 => 'localhost',
  ),
  'forwarded_for_headers' => array('HTTP_X_FORWARDED', 'HTTP_FORWARDED_FOR'),
  'apps_paths' => 
  array (
    0 => 
    array (
      'path' => '/var/www/html/apps',
      'url' => '/apps',
      'writable' => false,
    ),
    1 => 
    array (
      'path' => '/var/www/html/custom_apps',
      'url' => '/custom_apps',
      'writable' => true,
    ),
  ),
  'instanceid' => 'ocg3a10hyzpk',
);

if (isset($_SERVER['HTTP_X_FORWARDED_PREFIX'])) {
  $CONFIG['overwritewebroot'] = $_SERVER['HTTP_X_FORWARDED_PREFIX'];
}
 