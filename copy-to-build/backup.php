<?php
$path = realpath(dirname(__FILE__)) . DIRECTORY_SEPARATOR;
if(!file_exists($path.'config.php')) {
    echo "could not find config in ".$path.PHP_EOL;
    exit(3);
}

require $path.'config.php';

if(empty($mysqlExecPath)) {
    echo "mysql exec path is empty. fix it by editing config.php" . PHP_EOL;
}

$mysqlDir = realpath(dirname($mysqlExecPath));
$mysqldump = $mysqlDir . DIRECTORY_SEPARATOR . "mysqldump";

if (preg_match('/^win/i', PHP_OS)) {
    $mysqldump .= ".exe";
}

if(!file_exists($mysqldump)) {
    echo "could not find mysqldump under this path: $mysqldump". PHP_EOL;
}

$mysqldump = escapeshellcmd($mysqldump);
$user = escapeshellarg($user);

$filename = "MessageHandler-backup-".date("Y-m-d_H-i-s").".sql";

$exec = $mysqldump . " -uMessageHandlerBackup ";
if(!empty($backupPassword)) {
    $exec .= "-p$backupPassword ";
}
$exec .= "MessageHandler > " . $filename;

exec($exec, $discard, $return);

if($return !== 0) {
    exit(2);
}
