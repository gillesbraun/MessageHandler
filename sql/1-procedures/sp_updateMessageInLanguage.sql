/*----------------------------------------------------------------------------
| Routine : sp_updateMessageInLanguage
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Updates the translation of a message.
|
| Parameters :
| ------------
|  IN  : idMessage  : The ID of the message
|        idLanguage : The ID of the language
|        dtMessage  : The new message
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MsgHandler'@'localhost'
PROCEDURE sp_updateMessageInLanguage(
  IN i_idMessage  INT UNSIGNED,
  IN i_idLanguage CHAR(2),
  IN i_message    VARCHAR(500))
  SQL SECURITY DEFINER
  BEGIN
    UPDATE tblMessageInLanguage
    SET dtMessageInLanguage = i_message
    WHERE fiMessage = i_idMessage AND fiLanguage = i_idLanguage;
  END ??
