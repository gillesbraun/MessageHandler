/*----------------------------------------------------------------------------
| Routine : sp_addMessage
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Adds a new message to the DB.
|
| Parameters :
| ------------
|  IN  : idMessageType : The ID of the MessageType
|        idLanguage    : Language ID
|        name          : Name of MessageType in language
|
|  OUT : code          : Return code of the procedure. 0 if no error. 1062 if duplicate entry
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MsgHandler'@'localhost'
PROCEDURE sp_addMessageType(
  IN  i_idMessageType CHAR(1),
  IN  i_idLanguage    CHAR(2),
  IN  i_name          VARCHAR(50),
  OUT o_code        SMALLINT UNSIGNED,
  OUT o_message     VARCHAR(100))
  SQL SECURITY DEFINER
  BEGIN
    DECLARE t_deadlock_timeout INT DEFAULT 0;
    DECLARE t_attempts INT DEFAULT 0;

    DECLARE dup CONDITION FOR 1062;
    DECLARE CONTINUE HANDLER FOR dup
    BEGIN
      SET o_code = 1062;
      CALL sp_getMsg(2, 'en', '', @msg, @result_code, @result_message);
      SET o_message = @msg;
    END;

    -- Foreign key exception
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
      SET o_code = 1452;
      CALL sp_getMsg(3, 'en', '', @m, @result_code, @result_message);
      SET o_message = @m;
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

        INSERT INTO tblMessageType (idMessageType, fiLanguage, dtName)
        VALUES (i_idMessageType, i_idLanguage, i_name);
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
