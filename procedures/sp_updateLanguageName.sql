/*----------------------------------------------------------------------------
| Routine : sp_updateLanguageName
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Updates the name of a language.
|
| Parameters :
| ------------
|  IN  : idMessage : The ID of the message you want to remove
|        dtMsgType : The ID of the new MessageType
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MsgHandler'@'localhost'
PROCEDURE sp_updateLanguageName(
  IN i_idLanguage CHAR(2),
  IN i_name       VARCHAR(100),
  OUT o_code      INT UNSIGNED,
  OUT o_message   VARCHAR(100))
  SQL SECURITY DEFINER
  BEGIN
    DECLARE deadlockOccured INT DEFAULT 0;
    DECLARE nbrOfAttempts INT DEFAULT 0;

    SET o_code = 0;
    SET o_message = "";

    -- Start a loop to try the transaction 3 times
    tra_loop: WHILE (nbrOfAttempts < 3) DO
      BEGIN
        -- Define an exit handler when deadlock occurs.
        DECLARE deadlock CONDITION FOR 1213;
        DECLARE EXIT HANDLER FOR deadlock
        BEGIN
          SET deadlockOccured = 1;
          ROLLBACK;
        END;
        START TRANSACTION;

        -- Do the action
        UPDATE tblLanguage
        SET dtName = i_name
        WHERE idLanguage = i_idLanguage;

        COMMIT;

      END;
      -- End of the block where deadlocks can occur

      IF deadlockOccured = 0
      THEN
        -- Leave when no deadlock occured
        LEAVE tra_loop;
      ELSE
        -- Try again if deadlock occured
        SET nbrOfAttempts = nbrOfAttempts + 1;
      END IF;
    END WHILE tra_loop;

    IF deadlockOccured = 1
    THEN
      CALL sp_getMsg(1, 'en', '3', @msg);
      SET o_message = @msg;
      SET o_code = 1213;
    END IF;
  END ??
