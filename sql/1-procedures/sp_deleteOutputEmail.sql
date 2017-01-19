/*----------------------------------------------------------------------------
| Routine : sp_deleteOutputEmail
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Removes an email output from the database.
|
| Parameters :
| ------------
|  IN  : idOutputEmail : The ID of the output you want to remove
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MsgHandler'@'localhost'
PROCEDURE sp_deleteOutputEmail(
  IN  i_idOutput INT UNSIGNED)
  SQL SECURITY DEFINER
  BEGIN
    DELETE FROM tblOutputEmail WHERE idOutputEmail = i_idOutput;
  END ??
