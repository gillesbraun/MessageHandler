/*----------------------------------------------------------------------------
| Routine : sp_updateMessageDescription
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Updates a messages' description.
|
| Parameters :
| ------------
|  IN  : idMessage     : The ID of the message you want to remove
|        dtDescription : The new description
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MsgHandler'@'localhost'
PROCEDURE sp_updateMessageDescription(
  IN i_idMessage   INT UNSIGNED,
  IN i_desc VARCHAR(255),
  OUT o_code        SMALLINT UNSIGNED,
  OUT o_message     VARCHAR(100))
  SQL SECURITY DEFINER
  BEGIN
    DECLARE t_deadlock_timeout INT DEFAULT 0;
    DECLARE t_attempts INT DEFAULT 0;

    DECLARE dup_key CONDITION FOR 1062;
    DECLARE EXIT HANDLER FOR dup_key
    BEGIN
      SET o_code = 1062;
      CALL sp_getMsg(2, 'en', '', @msg, @result_code, @result_message);
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

        UPDATE tblMessage
        SET dtDescription = i_desc
        WHERE idMessage = i_idMessage;

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
