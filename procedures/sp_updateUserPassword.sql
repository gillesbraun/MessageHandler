/*----------------------------------------------------------------------------
| Routine : sp_updateUserPassword
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Changes a users' password.
|
| Parameters :
| ------------
|  IN  : idUser     : The username of the user
|        dtPassword : The new password for the user
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MsgHandler'@'localhost'
PROCEDURE sp_updateUserPassword(
  IN i_idUser VARCHAR(32),
  IN i_pass   VARCHAR(32))
  SQL SECURITY DEFINER
  BEGIN
    START TRANSACTION;

    DECLARE l_salt CHAR(64);
    SELECT dtSalt
      FROM tblUser
      WHERE idUser = i_idUser
      INTO l_salt
      LOCK IN SHARE MODE;

    UPDATE tblUser
      SET dtPassword = SHA2(CONCAT(i_pass, l_salt), 256)
      WHERE idUser = i_idUser;

    COMMIT;
  END ??
