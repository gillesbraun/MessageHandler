/*----------------------------------------------------------------------------
| Routine : sp_addMessage
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Adds a new message to the DB.
|
| Parameters :
| ------------
|  IN  : idMessageType : The ID of the MessageType
|        idLanguage    : Language ID
|        name          : Name of MessageType in language
|
|  OUT : code          : Return code of the procedure. 0 if no error. 1062 if duplicate entry
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MsgHandler'@'localhost'
PROCEDURE sp_addMessageType(
  IN  i_idMessageType CHAR(1),
  IN  i_idLanguage    CHAR(2),
  IN  i_name          VARCHAR(50),
  OUT o_code        SMALLINT UNSIGNED,
  OUT o_message     VARCHAR(100))
  SQL SECURITY DEFINER
  BEGIN
    DECLARE dup CONDITION FOR 1062;
    DECLARE CONTINUE HANDLER FOR dup
    BEGIN
      SET o_code = 1062;
      CALL sp_getMsg(2, 'en', '', @msg);
      SET o_message = @msg;
    END;

    SET o_code = 0;
    SET o_message = "OK";

    INSERT INTO tblMessageType (idMessageType, fiLanguage, dtName)
      VALUES (i_idMessageType, i_idLanguage, i_name);

  END ??
