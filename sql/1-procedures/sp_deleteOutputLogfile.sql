/*----------------------------------------------------------------------------
| Routine : sp_deleteOutputLogfile
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Removes a logfile output from the database.
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
PROCEDURE sp_deleteOutputLogfile(
  IN  i_idOutput INT UNSIGNED)
  SQL SECURITY DEFINER
  BEGIN
    DELETE FROM tblOutputLogfile WHERE idOutputLogfile = i_idOutput;
  END ??
