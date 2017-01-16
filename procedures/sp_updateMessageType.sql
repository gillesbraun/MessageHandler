/*----------------------------------------------------------------------------
| Routine : sp_updateMessageType
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Updates the type of a message.
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
PROCEDURE sp_updateMessageType(
  IN i_idMessage INT UNSIGNED,
  IN i_msgtype   CHAR(1))
  SQL SECURITY DEFINER
  BEGIN
    UPDATE tblMessage
    SET fiMessageType = i_msgtype
    WHERE idMessage = i_idMessage;
  END ??
