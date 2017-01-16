/*----------------------------------------------------------------------------
| Routine : sp_deleteMessageType
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Deletes a MessageType from the database, and also removes
|               all messages of this type.
|
| Parameters :
| ------------
|  IN  : idMessageType : The ID of the MessageType you want to remove
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MsgHandler'@'localhost'
PROCEDURE sp_deleteMessageType(
  IN  i_idMessageType  CHAR(1))
  SQL SECURITY DEFINER
  BEGIN
    DELETE FROM tblMessageType WHERE idMessageType = i_idMessageType;
  END ??
