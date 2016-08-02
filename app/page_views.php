<?php

$count = 0;
$logFolder = realpath(dirname(__FILE__) . '/../log/views');

// create entry
$file = tempnam($logFolder, 'view_');
file_put_contents($file, '');

ob_start();
$return = system("ls -l $logFolder | wc -l");
ob_clean();
$return = (int) $return;
$count = $return - 1;

return $count;
