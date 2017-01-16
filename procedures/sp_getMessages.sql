/*----------------------------------------------------------------------------
| Routine : sp_getMessages
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Returns all messages.
|
| Parameters :
| ------------
|  OUT : o_out      : CSV string. Rows separated by ^ and Values by ~
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MsgHandler'@'localhost'
PROCEDURE sp_getMessages(OUT o_out TEXT)
  SQL SECURITY DEFINER
  BEGIN
    SELECT GROUP_CONCAT(
        CONCAT_WS('~', idMessage, fiUser, fiMessageType, dtDescription, dtCreatedTS, IFNULL(dtUpdatedTS, ''))
        SEPARATOR '^')
    FROM tblMessage
    INTO o_out;
  END ??
