/*----------------------------------------------------------------------------
| Routine : sp_getLanguageOfOutput
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Gets the language ID for the given output ID.
|
| Parameters :
| ------------
|  IN  : idOutput : The ID of the output you want to get the language from
|
|  OUT : o_lang   : The ID of the language the output has. 
|                   NULL if output does not exist.
|
| List of callers : (this routine is called by the following routines)
| -----------------
| sp_handleOutput
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MsgHandler'@'localhost'
PROCEDURE sp_getLanguageOfOutput(
  IN  i_idOutput INT UNSIGNED,
  OUT o_lang     CHAR(2),
  OUT o_code        SMALLINT UNSIGNED,
  OUT o_message     VARCHAR(100))
  SQL SECURITY DEFINER
  BEGIN
    DECLARE t_deadlock_timeout INT DEFAULT 0;
    DECLARE t_attempts INT DEFAULT 0;

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

        SELECT fiLanguage
        FROM tblOutput
        WHERE idOutput = i_idOutput
        INTO o_lang;

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
