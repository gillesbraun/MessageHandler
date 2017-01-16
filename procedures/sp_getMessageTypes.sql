/*----------------------------------------------------------------------------
| Routine : sp_getMessageTypes
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Returns all MessageTypes
|
| Parameters :
| ------------
|  OUT : o_out    : CSV string. Rows separated by ^ and Values by ~
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MsgHandler'@'localhost'
PROCEDURE sp_getMessageTypes(OUT o_out TEXT)
  SQL SECURITY DEFINER
  BEGIN
    SELECT GROUP_CONCAT(
        CONCAT_WS('~', idMessageType, fiLanguage, dtName)
        SEPARATOR '^')
    FROM tblMessageType
    INTO o_out;
  END ??
