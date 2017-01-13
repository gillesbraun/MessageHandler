/*----------------------------------------------------------------------------
| Routine : sp_getPendingEmail
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Returns all pending email entries and deletes them from the database.
|               This is used by a cronjob to periodically to send pending emails
| Parameters :
| ------------
|  OUT : o_out      : CSV string. Rows separated by ^ and Values by ~
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MessageHandler'@'localhost'
PROCEDURE sp_getPendingEmail(OUT o_out TEXT)
  SQL SECURITY DEFINER
  BEGIN
    SELECT GROUP_CONCAT(
        CONCAT_WS('~', idPendingLog, dtRecipient, dtSubject, dtBody)
        SEPARATOR '^')
    FROM tblPendingEmail, tblEmail
    WHERE idEmail = fiEmail
    INTO o_out;
    DELETE FROM tblPendingEmail;
  END ??
