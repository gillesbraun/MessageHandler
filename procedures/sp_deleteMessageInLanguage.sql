/*----------------------------------------------------------------------------
| Routine : sp_deleteMessageInLanguage
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Removes a translation for a given message in the given language.
|
| Parameters :
| ------------
|  IN  : idMessage : The ID of the message you want to remove
|  IN  : idLanguage : The ID of the language
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MessageHandler'@'localhost'
PROCEDURE sp_deleteMessageInLanguage(
  IN  i_idMessage INT UNSIGNED,
  IN  i_idLanguage INT UNSIGNED)
  SQL SECURITY DEFINER
  BEGIN
    DELETE FROM tblMessageInLanguage WHERE fiMessage = i_idMessage AND fiLanguage = i_idLanguage;
  END ??
