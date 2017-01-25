/*----------------------------------------------------------------------------
| Routine : sp_getMessageTypeInLanguage
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Gets the name of the given MessageType in the given language.
|
| Parameters :
| ------------
|  IN  : idMessageType : The ID of the MessageType
|        idLanguage    : The ID of the language
|
|  OUT : o_name        : The name in the language
|
| List of callers : (this routine is called by the following routines)
| -----------------
| sp_getMessageInLanguage
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MsgHandler'@'localhost'
PROCEDURE sp_getMessageTypeInLanguage(
  IN  i_idMessageType CHAR(1),
  IN  i_idLanguage    CHAR(2),
  OUT o_name          VARCHAR(50),
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

        SELECT dtName
        FROM tblMessageType
        WHERE idMessageType = i_idMessageType
              AND fiLanguage = i_idLanguage
        INTO o_name;
        IF ( o_name IS NULL ) THEN
          SET o_message = CONCAT('MessageType ', i_idMessageType, ' does not exist in language ', i_idLanguage, '!');
          SET o_code = 1;
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
