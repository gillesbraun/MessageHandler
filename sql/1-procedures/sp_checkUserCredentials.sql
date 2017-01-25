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
CREATE DEFINER = 'MsgHandler'@'localhost'
PROCEDURE sp_checkUserCredentials(
  IN  i_username VARCHAR(32),
  IN  i_password VARCHAR(64),
  OUT o_result   BOOLEAN,
  OUT o_code        SMALLINT UNSIGNED,
  OUT o_message     VARCHAR(100))
  SQL SECURITY DEFINER
  BEGIN
    DECLARE t_deadlock_timeout INT DEFAULT 0;
    DECLARE t_attempts INT DEFAULT 0;

    DECLARE l_passwordDB, l_salt VARCHAR(64);
    DECLARE l_founduser VARCHAR(32);

    SET o_result = FALSE;
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
      CALL sp_getMsg(1, 'en', t_attempts, o_message, @result_code, @result_message);
    END IF;
  END ??
