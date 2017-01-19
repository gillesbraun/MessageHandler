/*----------------------------------------------------------------------------
| Routine : sp_handleEmail
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Handles each email output for a given parent output.
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
PROCEDURE sp_handleEmail(
  IN i_idOutput INT UNSIGNED,
  IN i_body     TEXT)
  SQL SECURITY DEFINER
  BEGIN
    INSERT INTO tblPendingEmail(dtBody, fiOutputEmail)
      SELECT i_body, idOutputEmail
      FROM tblOutputEmail
      WHERE fiOutput = i_idOutput;
  END ??
