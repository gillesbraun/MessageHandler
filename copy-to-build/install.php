<?php
define('LE', "\r\n");
$path = dirname(__FILE__) . "/";
if(basename(dirname(__FILE__)) != "build") {
    echo "Please run this script from the `build` directory" . LE;
    exit(1);
}
if (!function_exists('mysqli_connect')) {
    echo "Please install mysqli to use this script". LE;
    exit(1);
}
if(!file_exists($path.'MessageHandler.sql')) {
    echo "No install script available (MessageHandler.sql). Have you compiled it yet?" . LE;
    exit(1);
}

echo "To install MessageHandler, you need administrative access to create the databases and users." . LE;
$user = readline("Please enter a username from an administrative user: ");
$password = prompt_silent();

$mysqli = @new MySQLi('127.0.0.1', $user, $password, 'mysql');
if($mysqli->connect_error) {
    die($mysqli->connect_error . LE);
}


$mysqli->multi_query(file_get_contents($path.'MessageHandler.sql'));
if(sizeof($mysqli->error_list) > 0) {
    print_r($mysqli->error_list);
    echo "Installation was not successful. ". LE;
    exit(1);
}
echo "Installation OK" . LE;

$mysqli = @new MySQLi('127.0.0.1', $user, $password, 'mysql');
$newPass = prompt_silent("Would you like to change the password for the default MessageHandler user? Leave blank if not. ");
if(strlen($newPass) > 0) {
    $pass = $mysqli->real_escape_string($newPass);
    $mysqli->query("SET PASSWORD FOR MessageHandler@localhost = PASSWORD('".$pass."')");
    if(sizeof($mysqli->error_list) > 0) {
        print_r($mysqli->error_list);
        exit(1);
    }
    echo "Updating of password OK." . LE;
}

exit(0);

function prompt_silent($prompt = "Enter Password: ") {
    if (preg_match('/^win/i', PHP_OS)) {
        $vbscript = sys_get_temp_dir() . 'prompt_password.vbs';
        file_put_contents(
            $vbscript, 'wscript.echo(InputBox("'
            . addslashes($prompt)
            . '", "", "password here"))');
        $command = "cscript //nologo " . escapeshellarg($vbscript);
        $password = rtrim(shell_exec($command));
        unlink($vbscript);
        return $password;
    } else {
        $command = "/usr/bin/env bash -c 'echo OK'";
        if (rtrim(shell_exec($command)) !== 'OK') {
            trigger_error("Can't invoke bash");
            return;
        }
        $command = "/usr/bin/env bash -c 'read -s -p \""
            . addslashes($prompt)
            . "\" mypassword && echo \$mypassword'";
        $password = rtrim(shell_exec($command));
        echo "\n";
        return $password;
    }
}