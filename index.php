<?php
defined('YII_DEBUG') or define('YII_DEBUG',false);
defined('YII_TRACE_LEVEL') or define('YII_TRACE_LEVEL',3);
defined('YII_PATH') or define('YII_PATH',dirname(__FILE__).'/../framework/yii/framework');

require_once(dirname(__FILE__).'/../framework/redlib/red.php');
$config = dirname(__FILE__).'/protected/config/main.php';
Yii::createThriftApplication($config)->run();