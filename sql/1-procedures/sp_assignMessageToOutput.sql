/*----------------------------------------------------------------------------
| Routine : sp_assignMessageToOutput
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Assigns a message to an output. So every time the message
|               is generated, it is also sent to these outputs
|
| Parameters :
| ------------
|  IN  : idMessage    : The ID of the message you want to assign
|        idOutput     : The ID of the output you want to send the message to
|
|  OUT : o_code       : Statuscode of the procedure
|
| stdReturnValues :
| -----------------
|   stdReturnParameter  : o_exitCode
|   stdReturnValuesUsed : 0 : No error occurred
|   stdReturnValuesUsed : 1062 : When the message is already assigned to the output
|
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MsgHandler'@'localhost'
PROCEDURE sp_assignMessageToOutput(
  IN i_message INT UNSIGNED,
  IN i_output  INT UNSIGNED,
  OUT o_code        SMALLINT UNSIGNED,
  OUT o_message     VARCHAR(100))
  BEGIN
    DECLARE t_deadlock_timeout INT DEFAULT 0;
    DECLARE t_attempts INT DEFAULT 0;

    DECLARE dup CONDITION FOR 1062;
    DECLARE CONTINUE HANDLER FOR dup
    BEGIN
      SET o_code = 1062;
      CALL sp_getMsg(2, 'en', '', @msg);
      SET o_message = @msg;
    END;

    -- Foreign key exception
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
      SET o_code = 1452;
      CALL sp_getMsg(3, 'en', '', @m);
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

        INSERT INTO tblMessageOutput (fiMessage, fiOutput) VALUES
        (i_message, i_output);

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
