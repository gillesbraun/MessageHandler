<?php
chdir(realpath(dirname(__FILE__)));
new Installer();

class Installer
{
    private $scriptPath;
    private $mysqlRootUser;
    private $mysqlExecPath;

    function __construct()
    {
        if($this->preInstallChecks()) {
            $this->fetchMysqlExecutableOrElsePrompt();
            $this->install();
            $this->askChangePassword();
        } else {
            exit(1);
        }
    }

    private function install()
    {
        echo "To install MessageHandler, you need administrative access to create the databases and users." . PHP_EOL;
        $u = self::readinput("Please enter a username from an MySQL admin user: ");
        if(strlen(trim($u)) === 0) {
            echo "You have to provide an administrative user to install MessageHandler." . PHP_EOL;
            exit(1);
        }
        $this->mysqlRootUser = escapeshellarg($u);
        $this->fetchMysqlExecutableOrElsePrompt();
        $escapedScript = escapeshellarg($this->scriptPath);
        echo "Please enter the password for the administrative user." . PHP_EOL;
        exec($this->mysqlExecPath . ' -u' . $this->mysqlRootUser . ' -p < ' . $escapedScript, $discard, $returnval);
        if($returnval !== 0) {
            echo "Could not install script. Output from mysql should be above." . PHP_EOL;
            exit(1);
        }
    }

    private function askChangePassword()
    {
        $newPass = $this->prompt_silent("Enter the password for the MessageHandler user if you want to change it: ");
        if (strlen($newPass) > 0) {
            self::saveVariableToConfig("password", $newPass);
            $sql = "SET PASSWORD FOR MessageHandler@localhost = PASSWORD('$newPass')";
            echo "Please enter the password for the administrative user." . PHP_EOL;
            exec($this->mysqlExecPath . ' -u' . $this->mysqlRootUser . ' -p -e "'. $sql .'"', $discard, $exitCode);
            if($exitCode === 0) {
                echo "Updating of password OK." . PHP_EOL;
            } else {
                echo "Updating of password failed. Errors should be above." . PHP_EOL;
            }
        } else {
            self::saveVariableToConfig("password", "MSGHANDLER");
        }
    }

    private function preInstallChecks()
    {
        $path = dirname(__FILE__) . "/";
        $ok = true;
        if (basename(dirname(__FILE__)) != "build") {
            echo "Please run this script from the `build` directory" . PHP_EOL;
            $ok = false;
        }
        if (!function_exists('mysqli_connect')) {
            echo "Please install mysqli to use this script" . PHP_EOL;
            $ok = false;
        }
        if (!file_exists($path . 'MessageHandler.sql')) {
            echo "No install script available (MessageHandler.sql). Have you compiled it yet?" . PHP_EOL;
            $ok = false;
        }
        $this->scriptPath = $path . 'MessageHandler.sql';
        return $ok;
    }

    private function fetchMysqlExecutableOrElsePrompt()
    {
        if (preg_match('/^win/i', PHP_OS)) {
            $path = exec('where mysql', $discard, $returnval);
            if($returnval !== 0) {
                $path = $this->askForMysqlExecutable();
            }
            $this->setMysqlExecPath($path);
        } else {
            $path = exec('which mysql');
            if (strlen(trim($path)) === 0) {
                $this->setMysqlExecPath($this->askForMysqlExecutable());
            } else {
                $this->setMysqlExecPath($path);
            }
        }
    }

    private function setMysqlExecPath($p) {
        self::saveVariableToConfig("mysqlExecPath", $p);
        $this->mysqlExecPath = escapeshellcmd($p);
    }

    private function askForMysqlExecutable($retry = false)
    {
        if (!$retry) {
            echo "Could not find mysql executable in PATH." . PHP_EOL;
        }
        $userPath = trim(self::readinput("Please enter the path to a mysql client: "));
        if (strlen($userPath) === 0 || !file_exists($userPath) || strtolower(basename($userPath, ".exe")) !== "mysql") {
            echo PHP_EOL . "The path you entered does not seem to be corrent (" . $userPath . "). Try again." . PHP_EOL;
            return $this->askForMysqlExecutable(true);
        } else {
            return $userPath;
        }
    }

    private function prompt_silent($prompt = "Enter Password: ")
    {
        if (preg_match('/^win/i', PHP_OS)) {
            $vbscript = sys_get_temp_dir() . 'prompt_password.vbs';
            file_put_contents(
                $vbscript, 'wscript.echo(InputBox("'
                . addslashes($prompt)
                . '", "", ""))');
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

    private static function readinput($text = "") {
        if (preg_match('/^win/i', PHP_OS)) {
            echo $text;
            return stream_get_line(STDIN, 1024, PHP_EOL);
        } else {
            return readline($text);
        }
    }

    private static function saveVariableToConfig($var, $val) {
        if(!file_exists('config.php')) {
            echo "config.php not present, aborting" .PHP_EOL;
            exit(2);
        }
        $current_content = file_get_contents('config.php');
        // Replace single backslash with double
        $val = str_replace('\\', '\\\\', $val);
        // Replace quotations
        $val = str_replace('"', '', $val);
        if(strpos($current_content, '$'.$var) === false) {
            file_put_contents('config.php', '$'.$var.' = "'. $val .'";' . PHP_EOL, FILE_APPEND);
        }
    }
}
