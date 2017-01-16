/*----------------------------------------------------------------------------
| Routine : sp_getMessageTypeInLanguage
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Gets the name of the given MessageType in the given language.
|
| Parameters :
| ------------
|  IN  : idMessageType : The ID of the MessageType
|        idLanguage    : The ID of the language
|
|  OUT : o_name        : The name in the language
|
| List of callers : (this routine is called by the following routines)
| -----------------
| sp_getMessageInLanguage
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MsgHandler'@'localhost'
PROCEDURE sp_getMessageTypeInLanguage(
  IN  i_idMessageType CHAR(1),
  IN  i_idLanguage    CHAR(2),
  OUT o_name          VARCHAR(50))
  SQL SECURITY DEFINER
  BEGIN
    SELECT dtName
    FROM tblMessageType
    WHERE idMessageType = i_idMessageType
      AND fiLanguage = i_idLanguage
    INTO o_name;
    IF ( o_name IS NULL ) THEN
      SET o_name = CONCAT('MessageType ', i_idMessageType, ' does not exist in language ', i_idLanguage, '!');
    END IF;
  END ??
