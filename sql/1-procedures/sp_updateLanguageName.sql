/*----------------------------------------------------------------------------
| Routine : sp_updateLanguageName
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Updates the name of a language.
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
CREATE DEFINER = 'MsgHandler'@'localhost'
PROCEDURE sp_updateLanguageName(
  IN i_idLanguage CHAR(2),
  IN i_name       VARCHAR(100))
  SQL SECURITY DEFINER
  BEGIN

    UPDATE tblLanguage
    SET dtName = i_name
    WHERE idLanguage = i_idLanguage;
  END ??
