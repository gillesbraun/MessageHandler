<?php
$sql = file_get_contents('initDB.sql');
$sql .= file_get_contents('createUser.sql');
$sql .= file_get_contents('createTables.sql');

$files = scandir('procedures');
for($i = 2; $i < sizeof($files); $i++) {
    if(substr($files[$i], strlen($files[$i])-3) === "sql")
        $sql .= file_get_contents('procedures/' . $files[$i]);
}
$sql .= file_get_contents('fillWithData.sql');

file_put_contents('MessageHandler.sql', $sql);
