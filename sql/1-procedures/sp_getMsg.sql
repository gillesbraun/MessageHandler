/*----------------------------------------------------------------------------
| Routine : sp_getMsg
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Gets a message translation from the DB and replaces the placeholders
|               with the given placeholder parameters and redirects it to their outputs.
|
| Parameters :
| ------------
|   IN : idMessage  : The ID of the message
|        idLanguage : The ID of the language
|        replace    : The replacement for the placeholders. To replace multiple
|                     placeholders, separate them using #!
|
|  OUT : o_out      : The finished message
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MsgHandler'@'localhost'
PROCEDURE sp_getMsg(
  IN  i_idMessage  INT UNSIGNED,
  IN  i_idLanguage CHAR(2),
  IN  i_replace    TEXT,
  OUT o_out        VARCHAR(500),
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

        CALL sp_getMessageInLanguage(i_idMessage, i_idLanguage, i_replace, @m);
        SET o_out = @m;
        CALL sp_handleOutput(i_idMessage, i_replace);

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
