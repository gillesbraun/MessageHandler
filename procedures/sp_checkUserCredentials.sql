/*----------------------------------------------------------------------------
| Routine : sp_addLanguage
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Adds a language into the database.
|
| Parameters :
| ------------
|  IN  : idUsername   : The username of the user
|        dtPassword   : The password of the user
|
|  OUT : o_result     : Result for the credentials
|
| stdReturnValues :
| -----------------
|   stdReturnParameter  : o_result
|   stdReturnValuesUsed : 0 : The credentials are wrong
|   stdReturnValuesUsed : 1 : The credentials are right
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MessageHandler'@'localhost'
PROCEDURE sp_checkUserCredentials(
  IN  i_username VARCHAR(32),
  IN  i_password VARCHAR(64),
  OUT o_result   BOOLEAN)
  SQL SECURITY DEFINER
  BEGIN
    DECLARE l_passwordDB, l_salt VARCHAR(64);
    DECLARE l_founduser VARCHAR(32);
    SET o_result = FALSE;
    SELECT
      idUser,
      dtPassword,
      dtSalt
    FROM tblUser
    WHERE idUser = i_username
    INTO l_founduser, l_passwordDB, l_salt;
    IF l_founduser IS NOT NULL
    THEN
      IF SHA2(CONCAT(i_password, l_salt), 256) = l_passwordDB
      THEN
        SET o_result = TRUE;
      END IF;
    END IF;
  END ??

