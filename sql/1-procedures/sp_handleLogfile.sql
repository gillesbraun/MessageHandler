/*----------------------------------------------------------------------------
| Routine : sp_handleLogfile
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Handles each logfile output for a given parent output.
|
| Parameters :
| ------------
|   IN : idOutput : The ID of the output
|        body     : The text to send in the email
|
| List of callers : (this routine is called by the following routines)
| -----------------
| sp_handleOutput
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MsgHandler'@'localhost'
PROCEDURE sp_handleLogfile(
  IN i_idOutput INT UNSIGNED,
  IN i_msg      TEXT)
  SQL SECURITY DEFINER
  BEGIN
    INSERT INTO tblPendingLog(dtMsg, fiOutputLogfile)
      SELECT i_msg, idOutputLogfile
      FROM tblOutputLogfile
      WHERE fiOutput = i_idOutput;
  END ??