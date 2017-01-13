/*----------------------------------------------------------------------------
| Routine : sp_getMsg
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Gets a message translation from the DB and replaces the placeholders
|               with the given placeholder parameters and redirects it to their outputs.
|
| Parameters :
| ------------
|   IN : idMessage  : The ID of the message
|        idLanguage : The ID of the language
|        replace    : The replacement for the placeholders. To replace multiple
|                     placeholders, separate them using #!
|
|  OUT : o_out      : The finished message
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MessageHandler'@'localhost'
PROCEDURE sp_getMsg(
  IN  i_idMessage  INT UNSIGNED,
  IN  i_idLanguage CHAR(2),
  IN  i_replace    TEXT,
  OUT o_out        VARCHAR(500))
  SQL SECURITY DEFINER
  BEGIN
    CALL sp_getMessageInLanguage(i_idMessage, i_idLanguage, i_replace, @msg);
    SET o_out = @msg;
    CALL sp_handleOutput(i_idMessage, i_replace);

  END ??
