/*----------------------------------------------------------------------------
| Routine : sp_handleTwitter
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-12-21
|
| Description : Handles each Twitter output for a given parent output.
|
| Parameters :
| ------------
|   IN : idOutput : The ID of the output
|        body     : The text to send
|
| List of callers : (this routine is called by the following routines)
| -----------------
| sp_handleOutput
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MsgHandler'@'localhost'
PROCEDURE sp_handleTwitter(
  IN i_idOutput INT UNSIGNED,
  IN i_msg      TEXT)
  SQL SECURITY DEFINER
  BEGIN
    INSERT INTO tblPendingTwitter(dtMessage, fiOutputTwitter)
      SELECT i_msg, idOutputTwitter
      FROM tblOutputTwitter
      WHERE fiOutput = i_idOutput;
  END ??