/*----------------------------------------------------------------------------
| Routine : sp_deleteUser
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Deletes the given user
|
| Parameters :
| ------------
|  IN  : idUser : The username of the user
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MessageHandler'@'localhost'
PROCEDURE sp_deleteUser(
  IN  i_idUser  VARCHAR(32))
  SQL SECURITY DEFINER
  BEGIN
    DELETE FROM tblUser WHERE idUser = i_idUser;
  END ??
