<?php
// Create build directory
if(!is_dir('build')) {
    mkdir('build');
}
$path = 'build' . DIRECTORY_SEPARATOR;

// Compile SQL
compileSQL($path);

// Copy additional files to build dir
copyFilesToBuild($path);

if(!is_dir($path."backups")) {
    mkdir($path."backups", 0700);
}

// Functions

function compileSQL($outputPath) {
    // Gather sql files
    $sqlDirectories = scandir_r("sql");

    $sql = "";
    foreach($sqlDirectories as $directory) {
        foreach($directory as $file) {
            $sql .= file_get_contents($file);
        }
    }
    file_put_contents($outputPath.'MessageHandler.sql', $sql);
}

function scandir_r($dir) {
    $dirs = array();
    foreach (scandir($dir) as $file) {
        if($file != "." && $file != "..") {
            if(is_dir($dir."/".$file)) {
                $dirs[$file] = scandir_r($dir."/".$file);
            } else {
                if(substr($file, strlen($file)-3) === "sql") {
                    $dirs[] = $dir . "/" . $file;
                }
            }
        }
    }
    return $dirs;
}

function copyFilesToBuild($outputPath) {
    foreach (scandir("copy-to-build") as $file) {
        if($file != "." && $file != "..") {
            copy("copy-to-build/".$file, $outputPath.$file);
        }
    }
}
