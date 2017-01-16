/*----------------------------------------------------------------------------
| Routine : sp_getLanguagesNotUsedInMessage
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Returns all languages (ID, Name, LocalizedName) for which
|               there is no translation of a message.           
|
| Parameters :
| ------------
|   IN : idMessage : The ID of the message
|
|  OUT : o_out     : CSV string. Rows separated by ^ and Values by ~
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MsgHandler'@'localhost'
PROCEDURE sp_getLanguagesNotUsedInMessage(
  IN  i_idMessage INT UNSIGNED,
  OUT o_out       TEXT)
  SQL SECURITY DEFINER
  BEGIN
    SELECT GROUP_CONCAT(
        CONCAT_WS('~', idLanguage, tblLanguage.dtName, dtLocalizedName)
        SEPARATOR '^')
    FROM tblLanguage
    WHERE idLanguage NOT IN (SELECT DISTINCT fiLanguage
                             FROM tblMessageInLanguage
                             WHERE fiMessage = i_idMessage)
    INTO o_out;
  END ??
