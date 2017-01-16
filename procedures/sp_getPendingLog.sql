/*----------------------------------------------------------------------------
| Routine : sp_getPendingLog
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Returns all pending log entries and deletes them from the database.
|               This is used by a cronjob to periodically write all the messages
|               to the log files.
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
PROCEDURE sp_getPendingLog(OUT o_out TEXT)
  SQL SECURITY DEFINER
  BEGIN
    SELECT GROUP_CONCAT(
        CONCAT_WS('~', idPendingLog, dtPath, dtMsg)
        SEPARATOR '^')
    FROM tblPendingLog, tblLogfile
    WHERE idLogfile = fiLogfile
    INTO o_out;

    DELETE FROM tblPendingLog;
  END ??
