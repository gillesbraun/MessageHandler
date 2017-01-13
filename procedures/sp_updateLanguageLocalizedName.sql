/*----------------------------------------------------------------------------
| Routine : sp_updateLanguageLocalizedName
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Updates the localized name of a language. This is the
|               name of the language in the language itself.
|
| Parameters :
| ------------
|  IN  : idMessage : The ID of the message you want to remove
|        dtMsgType : The ID of the new MessageType
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MessageHandler'@'localhost'
PROCEDURE sp_updateLanguageLocalizedName(
  IN i_idLanguage CHAR(2),
  IN i_name   VARCHAR(100))
  SQL SECURITY DEFINER
  BEGIN
    UPDATE tblLanguage
      SET dtLocalizedName = i_name
      WHERE idLanguage = i_idLanguage;
  END ??
