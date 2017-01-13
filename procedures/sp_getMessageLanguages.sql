/*----------------------------------------------------------------------------
| Routine : sp_getMessageLanguages
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Returns all translations (idLang, LocalizedLanguage, translation)
|               for the given message.
|
| Parameters :
| ------------
|   IN : i_idMessage : The ID of the message
|
|  OUT : o_out       : CSV string. Rows separated by ^ and Values by ~
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MessageHandler'@'localhost'
PROCEDURE sp_getMessageLanguages(
  IN  i_idMessage  INT UNSIGNED,
  OUT o_out TEXT)
  SQL SECURITY DEFINER
  BEGIN
    SELECT GROUP_CONCAT(
        CONCAT_WS('~', fiLanguage, tblLanguage.dtName, dtMessageInLanguage)
        SEPARATOR '^')
    FROM tblMessageInLanguage, tblLanguage
    WHERE fiLanguage = tblLanguage.idLanguage AND fiMessage = i_idMessage
    INTO o_out;
  END ??
