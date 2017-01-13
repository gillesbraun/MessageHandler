/*----------------------------------------------------------------------------
| Routine : sp_deleteOutput
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Removes an output from the database. All suboutputs that are
|               assigned to the output will also be removed.
|
| Parameters :
| ------------
|  IN  : idOutput : The ID of the output you want to remove
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MessageHandler'@'localhost'
PROCEDURE sp_deleteOutput(
  IN  i_idOutput INT UNSIGNED)
  SQL SECURITY DEFINER
  BEGIN
    DELETE FROM tblOutput WHERE idOutput = i_idOutput;
  END ??
