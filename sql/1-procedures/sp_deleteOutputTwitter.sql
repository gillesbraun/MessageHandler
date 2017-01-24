/*----------------------------------------------------------------------------
| Routine : sp_deleteOutputTwitter
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2017-01-24
|
| Description : Removes a Twitter output from the database.
|
| Parameters :
| ------------
|  IN  : idOutputLogfile : The ID of the output you want to remove
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MsgHandler'@'localhost'
PROCEDURE sp_deleteOutputTwitter(
  IN  i_idOutput INT UNSIGNED)
  SQL SECURITY DEFINER
  BEGIN
    DELETE FROM tblOutputTwitter WHERE idOutputTwitter = i_idOutput;
  END ??
