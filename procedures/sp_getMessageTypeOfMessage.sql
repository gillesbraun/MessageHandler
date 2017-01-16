/*----------------------------------------------------------------------------
| Routine : sp_getMessageTypeOfMessage
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Returns the MessageType of the given message.
|
| Parameters :
| ------------
|  IN  : idMessage : The ID of the Message
|
|  OUT : o_msgtype : The MessageType of the message
|
| List of callers : (this routine is called by the following routines)
| -----------------
| sp_getMessageInLanguage
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MsgHandler'@'localhost'
PROCEDURE sp_getMessageTypeOfMessage(
  IN  i_idMessage INT UNSIGNED,
  OUT o_msgtype   CHAR(1))
  SQL SECURITY DEFINER
  BEGIN
    SELECT fiMessageType
    FROM tblMessage
    WHERE
      idMessage = i_idMessage
    INTO o_msgtype;
  END ??
