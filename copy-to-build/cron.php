<?php
date_default_timezone_set('Europe/Luxembourg');

require "vendor/autoload.php";
use Abraham\TwitterOAuth\TwitterOAuth;

require 'config.php';

function csv2array($text, $preferTwoDimensions = false) {
    $result = array();
    $rows = explode('^', $text);

    foreach($rows as $row) {
        if(strlen($row) !== 0)
            $result[] = explode('~', $row);
    }
    if(sizeof($result) == 1 && !$preferTwoDimensions)
        return $result[0];
    return $result;
}

function email($to, $subject, $text) {
    $from = FROM_EMAIL;

    $message = "<h1>New Message:</h1><br>";
    $message .= $text;

    $header = "From:"+$from+" \r\n";
    $header .= "MIME-Version: 1.0 \r\n";
    $header .= "Content-type: text/html; charset=utf-8 \r\n";
	if(debug == true)
		echo "Sending email to $to. Subject: $subject. Body: $message" . "\n";
    mail($to,$subject,$message,$header);
}

function twitter($consumerKey, $consumerSecret, $AccessToken, $AccessTokenSecret, $message) {
    $connection = new TwitterOAuth($consumerKey, $consumerSecret, $AccessToken, $AccessTokenSecret);
    $content = $connection->get("account/verify_credentials");
    $statuses = $connection->post("statuses/update", ["status" => $message]);
    echo "Sending tweet" . "\n";
}

function logfile($file, $text) {
	$msg = "[".date("Y-m-d H:i:s")."] ".$text."\r\n";
	if(debug == true)
		echo "Writing to $file with the message: $msg" . "\n";
	file_put_contents($file, $msg, FILE_APPEND);
}

function doLogFiles(MySQLi $mysqli) {
    //get logs to write

    $mysqli->query('CALL sp_getPendingLogfile(@r, @c, @m)');
    $res = $mysqli->query('SELECT @r');
    if($res == false) {
        die('Something failed.');
    }
    $pending = csv2array($res->fetch_assoc()['@r'], true);

    foreach($pending as $log) {
        $file = $log[1];
        $text = $log[2];
        logfile($file, $text);
    }
}

function doEmails(MySQLi $mysqli) {
    // get emails to send

    $mysqli->query('CALL sp_getPendingEmail(@r, @c, @m)');
    $res = $mysqli->query('SELECT @r');
    if($res == false) {
        die('Something failed.');
    }
    $pending = csv2array($res->fetch_assoc()['@r'], true);

    foreach($pending as $email) {
        email($email[1], $email[2], $email[3]);
    }
}

function doTwitters(MySQLi $mysqli) {
    // get emails to send

    $mysqli->query('CALL sp_getPendingTwitter(@r, @c, @m)');
    $res = $mysqli->query('SELECT @r');
    if($res == false) {
        die('Something failed.');
    }
    $pending = csv2array($res->fetch_assoc()['@r'], true);
    foreach ($pending as $twitter) {
        $consumerKey = $twitter[0];
        $consumerSecret = $twitter[1];
        $AccessToken = $twitter[2];
        $AccessTokenSecret = $twitter[3];
        $message = $twitter[4];
        twitter($consumerKey, $consumerSecret, $AccessToken, $AccessTokenSecret, $message);
    }
}


//start sql conncetion
$mysqli = @new MySQLi('127.0.0.1', $user, $password, 'MessageHandler');
if(!empty($mysqli->connect_error)) {
    die('Connection error: '.$mysqli->connect_error."\n");
}

doLogFiles($mysqli);
doEmails($mysqli);
doTwitters($mysqli);
