DROP USER IF EXISTS 'MessageHandler'@'localhost';
DROP USER IF EXISTS 'MsgHandler'@'localhost';

CREATE USER 'MessageHandler'@'localhost' IDENTIFIED BY 'MSGHANDLER';
GRANT USAGE ON MessageHandler.* TO 'MessageHandler'@'localhost';

CREATE USER 'MsgHandler'@'localhost' IDENTIFIED BY 'MSGHANDLER' ACCOUNT LOCK;
GRANT ALL ON MessageHandler.* TO 'MsgHandler'@'localhost';
