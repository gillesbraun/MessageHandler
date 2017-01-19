/*----------------------------------------------------------------------------
| Routine : sp_deleteMessage
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Deletes a message from the database, as well as all 
|               translations.
|
| Parameters :
| ------------
|  IN  : idMessage : The ID of the message you want to remove
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MsgHandler'@'localhost'
PROCEDURE sp_deleteMessage(
  IN  i_idMessage  INT UNSIGNED)
  SQL SECURITY DEFINER
  BEGIN
    DELETE FROM tblMessage WHERE idMessage = i_idMessage;
  END ??
