/*----------------------------------------------------------------------------
| Routine : sp_deleteLanguage
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Removes a language from the database. All message translations 
|               in this language, MessageTypes, Outputs will also be removed.
|
| Parameters :
| ------------
|  IN  : idLanguage   : The ID of the language you want to remove
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MsgHandler'@'localhost'
PROCEDURE sp_deleteLanguage(
  IN  i_idLanguage  CHAR(2))
  SQL SECURITY DEFINER
  BEGIN
    DELETE FROM tblLanguage WHERE idLanguage = i_idLanguage;
  END ??
