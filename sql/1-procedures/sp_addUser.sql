/*----------------------------------------------------------------------------
| Routine : sp_addUser
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Adds a new message to the DB.
|
| Parameters :
| ------------
|  IN  : dtUsername : Username of the new user. Must be unique.
|        dtPassword : The new cleartext password. It is encrypted lateron.
|        isAdmin    : Boolean if the user is admin or not.
|
|  OUT : o_exitCode : Exit code for the procedure
|
| stdReturnValues :
| -----------------
|   stdReturnParameter  : o_code
|   stdReturnValuesUsed : 1062 : If username already exists.
|
| List of callers : (this routine is called by the following routines)
| -----------------
| 
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MsgHandler'@'localhost'
PROCEDURE sp_addUser(
  IN  i_username VARCHAR(32),
  IN  i_password VARCHAR(64),
  IN  i_isAdmin  BOOLEAN,
  OUT o_code        SMALLINT UNSIGNED,
  OUT o_message     VARCHAR(100))
  SQL SECURITY DEFINER
  BEGIN
    DECLARE t_deadlock_timeout INT DEFAULT 0;
    DECLARE t_attempts INT DEFAULT 0;

    DECLARE l_salt CHAR(64) DEFAULT SHA2(RAND(), 256);

    DECLARE dup CONDITION FOR 1062;
    DECLARE CONTINUE HANDLER FOR dup
    BEGIN
      SET o_code = 1062;
      CALL sp_getMsg(2, 'en', '', @msg);
      SET o_message = @msg;
    END;

    SET o_code = 0;
    SET o_message = "OK";

    -- Deadlock retry loop
    tra_loop:WHILE (t_attempts < 3) DO
      BEGIN
        DECLARE deadlock_detected CONDITION FOR 1213;
        DECLARE timeout_detected CONDITION FOR 1205;
        DECLARE EXIT HANDLER FOR deadlock_detected, timeout_detected
        BEGIN
          ROLLBACK;
          SET t_deadlock_timeout=1;
        END;
        SET t_deadlock_timeout=0;

        START TRANSACTION;

        SET i_password = SHA2(CONCAT(i_password, l_salt), 256);
        INSERT INTO tblUser (idUser, dtPassword, dtSalt, dtIsAdmin)
        VALUES (i_username, i_password, l_salt, i_isAdmin);

        COMMIT;

      END;
      IF t_deadlock_timeout = 0 THEN -- No deadlock or timeout, exit loop
        LEAVE tra_loop;
      ELSE
        SET t_attempts = t_attempts + 1;
      END IF;
    END WHILE tra_loop;

    IF t_deadlock_timeout = 1 THEN -- attempt resulted in deadlock
      SET o_code = 1;
      CALL sp_getMsg(1, 'en', t_attempts, o_message);
    END IF;
  END ??
