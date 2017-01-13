/*----------------------------------------------------------------------------
| Routine : sp_getMessageTypesInLanguage
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Returns all MessageTypes in a specific language
|
| Parameters :
| ------------
|   IN : idLanguage : The ID of the language
|
|  OUT : o_out      : CSV string. Rows separated by ^ and Values by ~
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MessageHandler'@'localhost'
PROCEDURE sp_getMessageTypesInLanguage( -- TODO: replace For by IN
  IN  i_idLanguage CHAR(2),
  OUT o_out TEXT
)
  SQL SECURITY DEFINER
  BEGIN
    SELECT GROUP_CONCAT(
        CONCAT_WS('~', idMessageType, dtName)
        SEPARATOR '^')
    FROM tblMessageType
      WHERE fiLanguage = i_idLanguage
    INTO o_out;
  END ??
