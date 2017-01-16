/*----------------------------------------------------------------------------
| Routine : sp_updateUserIsAdmin
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Sets a users' admin status.
|
| Parameters :
| ------------
|  IN : username : The username for the user
|       isAdmin  : Boolean if the user is going to be admin
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MsgHandler'@'localhost'
PROCEDURE sp_updateUserIsAdmin(
  IN i_username VARCHAR(32),
  IN i_isAdmin BOOLEAN
)
  SQL SECURITY DEFINER
  BEGIN
    UPDATE tbluser set dtIsAdmin = i_isAdmin WHERE idUser = i_username;
  END ??
